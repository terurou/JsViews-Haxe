/* Haxe externs for JsViews
 * Copyright 2014, terurou
 * Released under the MIT License.
 */
package js.jsviews;

@:native("$")
extern class JsViews {
    @:overload(function (name: String, markupOrSelector: String): Template{})
    @:overload(function (?name: String, templateOptions: TemplateOptions): Template{})
    @:overload(function (namedTemplates: {}, ?parentTemplate: String): JsViews{})
    static function templates(markupOrSelector: String): Template;

    static var render(default, never): Dynamic <{} -> String>;

    static var views: {
        function converters(name: String, fn: Dynamic -> String): Dynamic -> String;

        function tags(name: String, fn: Dynamic -> String): Dynamic -> String;

        function helpers(name: String, fn: Dynamic -> String): Dynamic -> String;
    };

    @:overload(function (object: {}): ObjectObservable{})
    static function observable(array: Array<Dynamic>) : ArrayObservable;

    @:overload(function (object: {}, ?path: String, myHandler: ObservableEvent -> ObservableEventArgs -> Void): {}{})
    static function observe(array: Array<Dynamic>, myHandler: ObservableEvent -> ObservableEventArgs -> Void) : {};

    @:overload(function (array: Array<Dynamic>): {}{})
    @:overload(function (object: {}): {}{})
    @:overload(function (object: {}, ?path: String, myHandler: ObservableEvent -> ObservableEventArgs -> Void): {}{})
    static function unobserve(array: Array<Dynamic>, myHandler: ObservableEvent -> ObservableEventArgs -> Void): {};
}


typedef Template = {
    function render(?data: {}, ?helpersOrContext: Dynamic): String;
}

typedef TemplateOptions = {
    markup: String,
    ?converters: { },
    ?helpers: { },
    ?tags: { }
}

typedef TagCtx = {>Template,
    var args(default, never): Array<Dynamic>;
    var params(default, never): String;
    var props(default, never): Dynamic;
    var content(default, never): Template;
    var views(default, never): Dynamic;
}

typedef ConverterCtx = {
    var args(default, never): Array<Dynamic>;
    var params(default, never): String;
    var props(default, never): Dynamic;
    var views(default, never): Dynamic;
}

private typedef Observable = {
    function observeAll(myHandler: ObservableEvent -> ObservableEventArgs -> Void): Void;
    function unobserveAll(myHandler: ObservableEvent -> ObservableEventArgs -> Void): Void;
}

typedef ObjectObservable = {>Observable,
    @:overload(function (newValues: {}): Template{})
    function setProperty(path: String, value: Dynamic): ObjectObservable;
}

typedef ArrayObservable = {>Observable,
    function insert(?index: Int, insertedItems: Dynamic): ArrayObservable;

    function remove(index: Int, ?numToRemove: Int): ArrayObservable;

    function move(oldIndex: Int, newIndex: Int, ?numToMove: Int): ArrayObservable;

    function refresh(index: Int): ArrayObservable;
}


typedef ObservableEvent = {
    target: {}, // Object or Array<Dynamic>
    data: {}    // JsViews metadata
}

typedef ObservableEventArgs = {
    change: ObservableEventType,

    ?path: String,      // object / set
    ?value: Dynamic,    // object / set
    ?oldValue: Dynamic, // object / set

    ?index: Int,             // array / insert, remove, move
    ?items: Array<Dynamic>,  // array / insert, move
    ?numToRemove: Int,       // array / remove
    ?oldIndex: Int,          // array / move
    ?oldItem: Dynamic        // array / refresh
}

// FIXME Rewrites with @:enum abstract (>= Haxe 3.2)
// http://nadako.tumblr.com/post/64707798715/cool-feature-of-upcoming-haxe-3-2-enum-abstracts
@:fakeEnum(String)
extern enum ObservableEventType {
    set;
    insert;
    remove;
    move;
    refresh;
}


class JsViewsTools {
    public static inline function toEnum(ea: ObservableEventArgs): EnumedObservableEventArgs {
        return switch (ea.change) {
            case set:
                Set(ea.path, ea.value, ea.oldValue);
            case insert:
                Insert(ea.index, ea.items);
            case remove:
                Remove(ea.index, ea.numToRemove);
            case move:
                Move(ea.oldIndex, ea.index, ea.items);
            case refresh:
                Refresh(ea.oldItem);
        }
    }

    public static inline function args(): Array<Dynamic> {
        return untyped __js__("Array.prototype.slice.call(arguments)");
    }

    public static inline function tagCtx(): TagCtx {
        return untyped __js__("this.tagCtx");
    }

    public static inline function converterCtx(): TagCtx {
        return untyped __js__("this.tagCtx");
    }
}

enum EnumedObservableEventArgs {
    Set(path: String, value: Dynamic, oldValue: Dynamic);
    Insert(index: Int, items: Array<Dynamic>);
    Remove(index: Int, numToRemove: Int);
    Move(oldIndex: Int, index: Int, items: Array<Dynamic>);
    Refresh(oldItem: Dynamic);
}