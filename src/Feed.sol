// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Feed {
    // Struct to represent a comment
    struct Comment {
        uint256 id;
        address poster;
        string content;
        uint256 timestamp;
    }

    // Struct to represent a bookmark
    struct Bookmark {
        uint256 commentId;
        uint256 timestamp;
    }

    // Array to store all comments
    Comment[] private comments;

    // Mapping from user address to their bookmarks
    mapping(address => Bookmark[]) private bookmarks;

    // Mapping from user address to their comments
    mapping(address => uint256[]) private userComments;

    // Event emitted when a new comment is posted
    event CommentPosted(uint256 indexed commentId, address indexed poster, string content, uint256 timestamp);

    // Event emitted when a comment is bookmarked
    event CommentBookmarked(address indexed user, uint256 indexed commentId, uint256 timestamp);

    // Post a comment
    function postComment(string calldata content) external {
        uint256 commentId = comments.length;

        comments.push(Comment({
            id: commentId,
            poster: msg.sender,
            content: content,
            timestamp: block.timestamp
        }));

        // Add the comment id to the user's comment list
        userComments[msg.sender].push(commentId);

        emit CommentPosted(commentId, msg.sender, content, block.timestamp);
    }

    // Bookmark a comment
    function bookmarkComment(uint256 commentId) external {
        require(commentId < comments.length, "Invalid comment ID");

        bookmarks[msg.sender].push(Bookmark({
            commentId: commentId,
            timestamp: block.timestamp
        }));

        emit CommentBookmarked(msg.sender, commentId, block.timestamp);
    }

    // Retrieve all comments by a specific user
    function getCommentsByUser(address user) external view returns (Comment[] memory) {
        uint256[] storage commentIds = userComments[user];
        Comment[] memory userCommentsArray = new Comment[](commentIds.length);

        for (uint256 i = 0; i < commentIds.length; i++) {
            userCommentsArray[i] = comments[commentIds[i]];
        }

        return userCommentsArray;
    }

    // Retrieve all comments
    function getAllComments() external view returns (Comment[] memory) {
        return comments;
    }

    // Retrieve all bookmarks for the caller
    function getBookmarks() external view returns (Bookmark[] memory) {
        return bookmarks[msg.sender];
    }

    // Retrieve the details of a specific comment
    function getCommentById(uint256 commentId) external view returns (Comment memory) {
        require(commentId < comments.length, "Invalid comment ID");
        return comments[commentId];
    }
}