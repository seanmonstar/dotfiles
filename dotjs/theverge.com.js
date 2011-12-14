var commentList = document.querySelector('.comment_master_list');
if (commentList) {
    window.console && console.log('Hiding buttload of comments');
    commentList.style.display = 'none';
    var header = document.querySelector('.comments-header');
    if (header) {
        header.addEventListener('click', function(e) {
            commentList.style.display = '';
        }, false);
    }
} else {
    window.console && console.log('No comment list found.');
}

var socialBox = document.querySelector('.social-media-column');
if (socialBox) {
    window.console && console.log('Killing social column.');
    socialBox.parentNode.removeChild(socialBox);
}
