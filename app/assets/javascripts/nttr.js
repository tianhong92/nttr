$(document).ready(function() {
    //
    // Tweet selectors.
    //

    var broadcast = {
        id: '#new_tweet',
        input: '#tweet_content',
        counter: '.broadcast-counter',
        errors: '.broadcast-errors'
    }

    var tweet = {
        type: '.tweet',
        content: '.tweet-content',
        list: '.tweets-list',
        del: '.tweet-delete',
        err: 'error-highlight',
        contentLink: 'tweet-content-link',
        max: 140
    }

    // AJAX submit new tweet.
    var animationTime = 400;

    //
    // Live tweet character count.
    //

    $.fn.tweetLengthCounter = function(args) {
        args = $.extend({}, {
            counter: '',
            max: tweet.max,
            tolerance: 15,
            warnClass: 'text-error',
            dispClass: 'display-none'
        }, args);

        this.on('keyup', function() {
            var tweetLength = $(this).val().length,
                // Counter text to display.
                text = args.max - tweetLength > 0 ? args.max - tweetLength: 0,
                // Bool: show text.
                disp = !tweetLength,
                // Bool: warning text class.
                warn = args.max - args.tolerance - tweetLength < 0;

            $(args.counter)
                .text(text)
                .toggleClass(args.dispClass, disp)
                .toggleClass(args.warnClass, warn);
        });

        return this;
    };

    // Display the length of your tweet below the message.
    $(broadcast.input).tweetLengthCounter({
        counter: broadcast.counter
    });

    function clearErrors() {
        $(broadcast.input).removeClass(tweet.err);
        $(broadcast.errors).empty();
    }

    //
    // Validate tweet length upon submission.
    //

    $.fn.maxTweetLength = function(maxLength, element) {
        function check() {
            return !!$(element).val().replace(/(\r|\n|\s|\t)/g, '') 
                   && $(element).val().length <= maxLength;
        }
       
        this.on('submit', check);
        return this;
    }

    $(broadcast.id).maxTweetLength(tweet.max, broadcast.input);

    // 
    // Send tweet on ctrl/command + enter.
    //

    $(broadcast.input).on('keydown', function(keys) {
        if (keys.ctrlKey || keys.metaKey && keys.keyCode === 13) {
            $(this).closest('form').submit();
        }
    });

    //
    // Tweet delete callback function.
    // Action has been separated so that it can be attached to AJAX elements.
    // Tweet is faded out before being removed.
    //

    function removeHook(err, data, state, xhr) {
        $(this).closest(tweet.type).fadeOut(animationTime, function() {
            $(this).remove();
        });
    }

    $(tweet.del).on('ajax:success', removeHook);

    //
    // AJAX add tweet callback.
    //
    
    $(broadcast.id).on('ajax:success', function(err, data) {
        // Clear input and reset errors upon submit.
        clearErrors();
        $(broadcast.input).val('');

        // Hide new tweet before it is prepended to the roster.
        $(data)
            .hide()
            .prependTo(tweet.list)
            .fadeIn(animationTime).find(tweet.del)
            .on('ajax:success', removeHook);
    }).on('ajax:error', function(err, xhr) {
        $(broadcast.input).addClass(tweet.err);
        $(broadcast.errors).append($(xhr.responseText));
        console.log(xhr);
    });

    //
    // Resize Sidebar User Card
    //

    $.fn.userCardWidth = function(minWidth) {
        function resizeUserCard() {
            var belowMin = $(this).width() < minWidth;
            $self.css('width', belowMin ? '100%' : $self.parent().width());

            if (!$self.is(':visible')) {
                // Element is hidden by default to avoid FOUC.
                $self.fadeIn(animationTime);
            }
        }

        minWidth = minWidth || 992;
        var $self = this;

        $(window)
            .on('resize', resizeUserCard)
            .trigger('resize');

        return this;
    }

    $('#usercard').userCardWidth(992);
});
