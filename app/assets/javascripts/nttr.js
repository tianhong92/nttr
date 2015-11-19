$(document).ready(function() {
    //
    // Tweet selectors.
    //

    var tweets = {
        form: {
            id: '#new_tweet',
            counter: '.broadcast__counter',
            input: '#tweet_content',
            errors: '.create__errors'
        },
        tweet: '.tweet',
        list: '.tweet-list',
        del: '.tweet__delete',
        err: 'error--highlight',
        max: 140
    };

    // AJAX submit new tweets.
    var animationTime = 400;

    //
    // Live tweet character count.
    //

    $.fn.tweetLengthCounter = function(args) {
        args = $.extend({}, {
            counter: '',
            max: tweets.max,
            tolerance: 15,
            warnClass: 'text--error',
            dispClass: 'display--none'
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
    $(tweets.form.input).tweetLengthCounter({
        counter: tweets.form.counter
    });

    function clearErrors() {
        $(tweets.form.input).removeClass(tweets.err);
        $(tweets.form.errors).empty();
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

    $(tweets.form.id).maxTweetLength(tweets.max, tweets.form.input);

    // 
    // Send tweet on ctrl/command + enter.
    //

    $(tweets.form.input).on('keydown', function(keys) {
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
        $(this).closest(tweets.tweet).fadeOut(animationTime, function() {
            $(this).remove();
        });
    }

    $(tweets.del).on('ajax:success', removeHook);

    //
    // AJAX add tweet callback.
    //
    
    $(tweets.form.id).on('ajax:success', function(err, data) {
        // Clear input and reset errors upon submit.
        clearErrors();
        $(tweets.form.input).val('');

        // Hide new tweet before it is prepended to the roster.
        $(data)
            .hide()
            .prependTo(tweets.list)
            .fadeIn(animationTime).find(tweets.del)
            .on('ajax:success', removeHook);
    }).on('ajax:error', function(err, xhr) {
        $(tweets.form.input).addClass(tweets.err);
        // console.log(JSON.parse(xhr.responseText));
        $(tweets.form.errors).append($(xhr.responseText));
        console.log(xhr);
    });
});
