function log () {
    if (window.console && console.log) {
        console.log.apply(console, arguments);
    }
}
