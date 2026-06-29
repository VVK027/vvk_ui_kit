import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/src/widgets/text/ui_text.dart';

/// Status of the [UILoadMoreContainer] data loading process.
enum UILoadMoreStatus {
  /// Not yet loaded.
  initial,

  /// Currently loading initial data.
  loading,

  /// Data loaded successfully.
  loaded,

  /// An error occurred during loading.
  error,

  /// No data found.
  empty,

  /// All data loaded, no more pages.
  finish,
}

/// The layout type for [UILoadMoreContainer].
enum UILoadMoreViewType {
  /// Linear list of items.
  list,

  /// Multi-column grid of items.
  grid,
}

/// A container that handles paginated loading, pull-to-refresh, and infinite scrolling.
///
/// It supports both list and grid views and manages loading, error, and empty states.
class UILoadMoreContainer<T> extends StatefulWidget {
  /// Function to load data for a specific page and limit.
  /// Returns a `Future` of `(List<T>, int)` — list of items and total count.
  final Future<(List<T>, int)> Function(int page, int limit) onLoadData;

  /// Number of items to request per page.
  final int limit;

  /// Builder for individual items in the list/grid.
  final Widget Function(BuildContext, T, int) itemBuilder;

  /// Optional widget to display during initial loading.
  final Widget? loadingWidget;

  /// Optional widget to display when no data is returned.
  final Widget? emptyWidget;

  /// Optional widget to display when an error occurs.
  final Widget? errorWidget;

  /// Optional widget to display at the bottom while loading the next page.
  final Widget? loadingMoreWidget;

  /// Padding for the scrollable area.
  final EdgeInsetsGeometry? padding;

  /// Distance from the end of the scrollable area to trigger loading more data.
  final double loadMoreOffset;

  /// Optional separator widget for list view mode.
  final Widget? separatorWidget;

  /// Optional external [ScrollController].
  final ScrollController? scrollController;

  /// Callback triggered when the loading state changes.
  final Function(bool)? onLoadingChanged;

  /// Callback triggered when an error occurs.
  final Function(dynamic)? onError;

  /// Whether to display as a list or a grid.
  final UILoadMoreViewType viewType;

  /// The grid delegate to use if [viewType] is [UILoadMoreViewType.grid].
  final SliverGridDelegate? gridDelegate;

  /// Color for the progress indicators.
  final Color? progressColor;

  /// Background color for the refresh indicator.
  final Color? refreshBackgroundColor;

  /// Custom message for the empty state.
  final String? emptyMessage;

  /// Custom message for the error state.
  final String? errorMessage;

  /// Label for the retry button in the error state.
  final String? errorRetryLabel;

  /// Creates a [UILoadMoreContainer].
  const UILoadMoreContainer({
    super.key,
    required this.onLoadData,
    required this.itemBuilder,
    this.limit = 20,
    this.loadingWidget,
    this.emptyWidget,
    this.errorWidget,
    this.loadingMoreWidget,
    this.padding,
    this.loadMoreOffset = 300.0,
    this.separatorWidget,
    this.scrollController,
    this.onLoadingChanged,
    this.onError,
    this.viewType = UILoadMoreViewType.list,
    this.gridDelegate,
    this.progressColor,
    this.refreshBackgroundColor,
    this.emptyMessage,
    this.errorMessage,
    this.errorRetryLabel,
  });

  UILoadMoreContainer<T> copyWith({
    Key? key,
    Future<(List<T>, int)> Function(int page, int limit)? onLoadData,
    Widget Function(BuildContext, T, int)? itemBuilder,
    int? limit,
    Widget? loadingWidget,
    Widget? emptyWidget,
    Widget? errorWidget,
    Widget? loadingMoreWidget,
    EdgeInsetsGeometry? padding,
    double? loadMoreOffset,
    Widget? separatorWidget,
    ScrollController? scrollController,
    Function(bool)? onLoadingChanged,
    Function(dynamic)? onError,
    UILoadMoreViewType? viewType,
    SliverGridDelegate? gridDelegate,
    Color? progressColor,
    Color? refreshBackgroundColor,
    String? emptyMessage,
    String? errorMessage,
    String? errorRetryLabel,
  }) {
    return UILoadMoreContainer<T>(
      key: key ?? this.key,
      onLoadData: onLoadData ?? this.onLoadData,
      itemBuilder: itemBuilder ?? this.itemBuilder,
      limit: limit ?? this.limit,
      loadingWidget: loadingWidget ?? this.loadingWidget,
      emptyWidget: emptyWidget ?? this.emptyWidget,
      errorWidget: errorWidget ?? this.errorWidget,
      loadingMoreWidget: loadingMoreWidget ?? this.loadingMoreWidget,
      padding: padding ?? this.padding,
      loadMoreOffset: loadMoreOffset ?? this.loadMoreOffset,
      separatorWidget: separatorWidget ?? this.separatorWidget,
      scrollController: scrollController ?? this.scrollController,
      onLoadingChanged: onLoadingChanged ?? this.onLoadingChanged,
      onError: onError ?? this.onError,
      viewType: viewType ?? this.viewType,
      gridDelegate: gridDelegate ?? this.gridDelegate,
      progressColor: progressColor ?? this.progressColor,
      refreshBackgroundColor:
          refreshBackgroundColor ?? this.refreshBackgroundColor,
      emptyMessage: emptyMessage ?? this.emptyMessage,
      errorMessage: errorMessage ?? this.errorMessage,
      errorRetryLabel: errorRetryLabel ?? this.errorRetryLabel,
    );
  }

  @override
  UILoadMoreContainerState<T> createState() => UILoadMoreContainerState<T>();
}

/// State class for [UILoadMoreContainer].
class UILoadMoreContainerState<T> extends State<UILoadMoreContainer<T>> {
  ScrollController? _internalScrollController;
  ScrollController get _effectiveController =>
      widget.scrollController ?? _internalScrollController!;

  // Widget state
  bool _isInitialized = false;
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _canLoadMore = true;
  bool _isError = false;

  // Data
  List<T> _items = [];
  int _currentPage = 1;
  int _totalItems = 0;
  dynamic _error;

  // Load more state
  bool _isTriggeredLoadMore = false;
  // Variable to track API calls
  bool _isRequestInProgress = false;

  @override
  void initState() {
    super.initState();
    if (widget.scrollController == null) {
      _internalScrollController = ScrollController();
    }

    _effectiveController.addListener(_scrollListener);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  @override
  void dispose() {
    _effectiveController.removeListener(_scrollListener);
    if (widget.scrollController == null) {
      _internalScrollController?.dispose();
    }
    super.dispose();
  }

  // Load initial data or refresh
  Future<void> _loadData() async {
    if (_isRequestInProgress) return;

    setState(() {
      _isLoading = true;
      _isError = false;
      _error = null;
      _isRequestInProgress = true;
    });

    if (widget.onLoadingChanged != null) {
      widget.onLoadingChanged!(true);
    }

    try {
      final result = await widget.onLoadData(1, widget.limit);

      // Update data and state
      _isInitialized = true;
      _currentPage = 1;
      _items = result.$1;
      _totalItems = result.$2;
      _canLoadMore = _items.length < _totalItems;
      _isError = false;
    } catch (e) {
      _isError = true;
      _error = e;
      if (widget.onError != null) {
        widget.onError!(e);
      }
    } finally {
      // Important: ensure state is updated when finished
      _isRequestInProgress = false;

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (widget.onLoadingChanged != null) {
          widget.onLoadingChanged!(false);
        }
      }
    }
  }

  // Load more data
  Future<void> _loadMoreData() async {
    if (_isLoadingMore || !_canLoadMore || _isRequestInProgress) return;

    setState(() {
      _isLoadingMore = true;
      _isRequestInProgress = true;
    });

    try {
      final nextPage = _currentPage + 1;
      final result = await widget.onLoadData(nextPage, widget.limit);
      final newItems = result.$1;
      final total = result.$2;

      if (newItems.isEmpty) {
        _canLoadMore = false;
        return;
      }

      _items.addAll(newItems);
      _currentPage = nextPage;
      _totalItems = total;
      _canLoadMore = _items.length < _totalItems;
    } catch (e) {
      widget.onError?.call(e);
    } finally {
      _isRequestInProgress = false;
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
        });
      }
    }
  }

  // Listener for scroll events
  void _scrollListener() {
    if (!_effectiveController.hasClients) return;

    if (_isTriggeredLoadMore ||
        !_canLoadMore ||
        _isLoadingMore ||
        _isLoading ||
        _isRequestInProgress) {
      return;
    }

    if (_effectiveController.position.pixels >
        _effectiveController.position.maxScrollExtent - widget.loadMoreOffset) {
      _isTriggeredLoadMore = true;

      _loadMoreData().then((_) {
        _isTriggeredLoadMore = false;
      });
    }
  }

  /// Refreshes the data by reloading the first page.
  Future<void> refresh({bool showInitialLoader = false}) async {
    if (showInitialLoader) {
      setState(() {
        _isInitialized = false;
        _items = [];
        _currentPage = 1;
        _totalItems = 0;
        _canLoadMore = true;
        _isError = false;
        _error = null;
      });
    }
    await _loadData();
  }

  /// The current list of items in the container.
  List<T> get items => _items;

  /// Manually adds an item to the beginning of the list.
  void addItem(T item) {
    setState(() {
      _items.insert(0, item);
      _totalItems++;
    });
  }

  /// Manually updates an item at a specific [index].
  void updateItem(int index, T item) {
    if (index >= 0 && index < _items.length) {
      setState(() {
        _items[index] = item;
      });
    }
  }

  /// Manually removes an item at a specific [index].
  void removeItem(int index) {
    if (index >= 0 && index < _items.length) {
      setState(() {
        _items.removeAt(index);
        _totalItems--;
      });
    }
  }

  Color _progressColor(BuildContext context) =>
      widget.progressColor ?? Theme.of(context).colorScheme.primary;

  Color _refreshBackgroundColor(BuildContext context) =>
      widget.refreshBackgroundColor ?? Theme.of(context).colorScheme.surface;

  @override
  Widget build(BuildContext context) {
    final progress = _progressColor(context);

    if (_isLoading) {
      return widget.loadingWidget ??
          Center(
            child: CircularProgressIndicator(color: progress, strokeWidth: 2),
          );
    }

    if (_isError) {
      return widget.errorWidget ?? _buildErrorWidget(context);
    }

    if (_isInitialized && _items.isEmpty) {
      return widget.emptyWidget ?? _buildEmptyWidget(context);
    }

    return RefreshIndicator(
      color: progress,
      backgroundColor: _refreshBackgroundColor(context),
      onRefresh: refresh,
      child: widget.viewType == UILoadMoreViewType.list
          ? ListView.separated(
              shrinkWrap: true,
              controller: _effectiveController,
              padding: widget.padding ?? const EdgeInsets.all(16),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: _items.length + (_isLoadingMore ? 1 : 0),
              separatorBuilder: (context, index) =>
                  widget.separatorWidget ?? const SizedBox(height: 8),
              itemBuilder: (context, index) {
                if (index == _items.length) {
                  return widget.loadingMoreWidget ??
                      _buildLoadingMoreWidget(context);
                }
                return widget.itemBuilder(context, _items[index], index);
              },
            )
          : GridView.builder(
              controller: widget.scrollController != null
                  ? null
                  : _effectiveController,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: widget.padding ?? const EdgeInsets.all(16),
              gridDelegate:
                  widget.gridDelegate ??
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 1,
                  ),
              itemCount: _items.length + (_isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _items.length) {
                  return widget.loadingMoreWidget ??
                      _buildLoadingMoreWidget(context);
                }
                return widget.itemBuilder(context, _items[index], index);
              },
            ),
    );
  }

  Widget _buildErrorWidget(BuildContext context) {
    final String? message = widget.errorMessage ?? _error?.toString();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
          if (message != null && message.isNotEmpty) ...[
            const SizedBox(height: 16),
            UIText(
              message,
              size: 16,
              color: Colors.grey[600],
              textAlign: TextAlign.center,
            ),
          ],
          if (widget.errorRetryLabel != null) ...[
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: refresh,
              child: UIText(widget.errorRetryLabel!),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyWidget(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_note_outlined, size: 64, color: Colors.grey[400]),
          if (widget.emptyMessage != null) ...[
            const SizedBox(height: 16),
            UIText(widget.emptyMessage!, size: 16, color: Colors.grey[600]),
          ],
        ],
      ),
    );
  }

  Widget _buildLoadingMoreWidget(BuildContext context) {
    final progress = _progressColor(context);
    return GridTile(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(progress),
            ),
          ),
        ),
      ),
    );
  }
}
