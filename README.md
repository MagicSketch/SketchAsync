SketchAsync
---

## Example: Global Event Emission

Execute "Plugin > SketchAsync > runObjcAsync"

```objective-c
- (void)runSomethingInBackgroundForSeconds:(NSTimeInterval)seconds {

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        NSString *actionID = @"SketchAsync.finish";
        NSObject *appController = [NSClassFromString(@"AppController") valueForKeyPath:@"sharedInstance"];
        NSObject *pluginManager = [appController valueForKeyPath:@"pluginManager"];
        NSDictionary *pluginContext = [appController valueForKeyPath:@"pluginContext"];


        NSMutableDictionary *context = [NSMutableDictionary dictionaryWithDictionary:pluginContext];

        context[@"SketchAsyncDuration"] = @(seconds);

        [pluginManager performSelector:NSSelectorFromString(@"sendToInterestedCommandsActionWithID:context:") withObject:actionID withObject:context];

    });


    // At the end of dispatch_after, `SketchAsync.finish` event will be emitted

}
```

### Registering for SketchAsync.finish

in manifest.json, similar to other actions API, register a specific event of what defined in the native side

```javascript
    {
        "script" : "script.cocoascript",
        "handlers" : {
            "actions" : {
                "SketchAsync.finish" : "onSketchAsyncFinish",
            }
        }
    }
```

in script.cocoscript, implement `onSketchAsyncFinish`

```javascript
var onSketchAsyncFinish = function(context) {
    log("js context: " + context);
    log("js onSketchAsyncFinish");
    var duration = context.actionContext.SketchAsyncDuration;
    context.actionContext.document.showMessage("onSketchAsyncFinish: " + duration + " seconds");
};
```

