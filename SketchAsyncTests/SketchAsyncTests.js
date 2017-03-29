
function sum(a, b) {
    return a + b;
}

function main(completion) {

    log("running main()");
    var async = SketchAsync.alloc().init();

    coscript.setShouldKeepAround(true);

    log("desc: "+ MOClassDescription.descriptionForClass(SketchAsync).instanceMethods());
    //async.runInBackground_onCompletion_(function() {
    async.runInBackground_onCompletion_(function() {

                         return sum(1, 6);
                     },
                     function(result) {
                         log("summing in background " + result);
                         completion();
                         coscript.setShouldKeepAround(false);
                     });



}

(function () {
    log("SketchAsyncTests.js loaded");
    return this;
})();
