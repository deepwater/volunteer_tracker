/**
 * jQuery Plugin: Sticky Tabs
 *
 * @author Aidan Lister <aidan@php.net>
 * @version 1.2.1 (was changed 07/18/2015)
 */
(function ( $ ) {
    $.fn.stickyTabs = function( options ) {
        var context = this

        var settings = $.extend({
            getHashCallback: function(hash, btn) { return hash },
            selectorAttribute: "href",
            backToTop: false,
            initialTab: $('li.active > a', context)
        }, options );

        // Show the tab corresponding with the hash in the URL, or the first tab.
        var showTabFromHash = function() {
          var eHash = settings.selectorAttribute == "href" ? window.location.hash : window.location.hash.substring(1);
          var anchors = eHash.split("_day_"); // ;( 
          var hash = anchors[0];
          var selectorTopLevel = anchors[0] ? 'a[' + settings.selectorAttribute +'="' + anchors[0] + '"]' : 'li:first > a:first';
          var selectorBottomLevel = anchors[1] ? 'a[' + settings.selectorAttribute +'="' + eHash + '"]' : anchors[0] + ' .days-list li:first > a:first';
          $(selectorTopLevel, context).tab('show');
          $(selectorBottomLevel).tab('show');
          $.cookie("tabs_anchor", eHash.split('#')[1]);
          setTimeout(backToTop, 1);
        }

        // We use pushState if it's available so the page won't jump, otherwise a shim.
        var changeHash = function(hash) {
          // TODO: it does not work, find out why
          // if (history && history.pushState) {
          //   console.log(window.location.pathname + window.location.search + '#' + hash);
          //   history.pushState(null, null, window.location.pathname + window.location.search + '#' + hash);
          // } else {
          scrollV = document.body.scrollTop;
          scrollH = document.body.scrollLeft;
          window.location.hash = hash;
          document.body.scrollTop = scrollV;
          document.body.scrollLeft = scrollH;
        }

        var backToTop = function() {
          if (settings.backToTop === true) {
            window.scrollTo(0, 0);
          }
        }

        // Set the correct tab when the page loads
        showTabFromHash();

        // Set the correct tab when a user uses their back/forward button
        $(window).on('hashchange', showTabFromHash);

        // Change the URL when tabs are clicked
        $('a', context).on('click', function(e) {
          var hash = this.href.split('#')[1];
          var adjustedhash = settings.getHashCallback(hash, this);
          changeHash(adjustedhash);
          setTimeout(backToTop, 1);
        });

        return this;
    };
}( jQuery ));