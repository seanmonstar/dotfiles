function disableSuperfluousPlusOnes() {
    var comments = document.querySelectorAll('.comment .content-body');
    if (comments.length > 20) {
        window.console && console.log('Removing +1 comments');
        Array.prototype.forEach.call(comments, function(el) {
            if (el.textContent.trim() == '+1') el.parentNode.removeChild(el);
        });
    }
}

disableSuperfluousPlusOnes();
