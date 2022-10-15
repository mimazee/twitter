// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract Twitter {
    // ----- START OF DO-NOT-EDIT ----- //
    struct Tweet {
        uint tweetId;
        address author;
        string content;
        uint createdAt;
    }

    struct User {
        address wallet;
        string name;
        uint[] userTweets;
    }

    mapping(address => User) public users;
    mapping(uint => Tweet) public tweets;
    uint256 public nextTweetId;
    // ----- END OF DO-NOT-EDIT ----- //

    function registerAccount(string calldata _name) external {
        require(bytes(_name).length != 0, "Name cannot be an empty string");
        User memory _newUser;
        _newUser.name = _name;
        _newUser.wallet = msg.sender;
        users[msg.sender] = _newUser;
    }

    function postTweet(string calldata _content) external accountExists(msg.sender) {
        Tweet memory newestTweet;
        newestTweet.tweetId = nextTweetId;
        newestTweet.author = msg.sender;
        newestTweet.content = _content;
        newestTweet.createdAt = block.timestamp;

        tweets[nextTweetId] = newestTweet;
        users[msg.sender].userTweets.push(nextTweetId);
        nextTweetId += 1;
    }

    function readTweets(address _user) view external returns(Tweet[] memory) {
        uint[] memory userTweetsId = users[_user].userTweets;
        uint userTweetLength = userTweetsId.length;
        Tweet[] memory userTweets = new Tweet[](userTweetLength);
        uint i;
        for(i = 0; i < userTweetLength; i++) {
            uint tweetId = userTweetsId[i];
            userTweets[i] = tweets[tweetId];
        }
        return userTweets;
    }

    modifier accountExists(address _user) {
        _;
        string memory _username = users[_user].name;
        require(bytes(_username).length != 0, "This wallet does not belong to any account.");
    }

}