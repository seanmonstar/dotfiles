var shareWidget = document.getElementById('post-share-widget');
if (shareWidget) {
    window.console && console.log('Removing techcrunches social widget.');
    shareWidget.parentNode.removeChild(shareWidget);
}
