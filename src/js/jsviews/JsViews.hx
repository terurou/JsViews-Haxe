/* Haxe externs for JsViews
 * Copyright 2014, terurou
 * Released under the MIT License.
 */
package js.jsviews;

import js.html.Element;

@:native("$")
extern class JsViews {
    @:overload(function (name: String, markupOrSelector: String): Template{})
    @:overload(function (?name: String, templateOptions: TemplateOptions): Template{})
    @:overload(function (namedTemplates: {}, ?parentTemplate: String): JsViews{})
    static function templates(markupOrSelector: String): Template;

    static var render(default, never): Dynamic<{} -> String>;

    static var views: {
        @:overload(function (namedConverters: {}, ?parentTemplate: String): Dynamic{})
        function converters(name: String, fn: Dynamic -> String): Dynamic;

        @:overload(function (namedTags: {}, ?parentTemplate: String): Dynamic{})
        function tags(name: String, fn: Dynamic -> String): Dynamic;

        @:overload(function (namedHelpers: {}, ?parentTemplate: String): Dynamic{})
        function helpers(name: String, fn: Dynamic -> String): Dynamic;
    };

    @:overload(function (flag: Bool, to: Element, from: {}, ?context: {}): Dynamic{})
    //@:overload(function (flag: Bool, to: JQuery, from: {}, ?context: {}): Dynamic{})
    @:overload(function (template: Template, to: String, from: {}, ?context: {}): Dynamic{})
    @:overload(function (template: Template, to: Element, from: {}, ?context: {}): Dynamic{})
    //@:overload(function (template: Template, to: JQuery, from: {}, ?context: {}): Dynamic{})
    static function link(flag: Bool, to: String, from: {}, ?context: {}): Dynamic; //JQuery

    @:overload(function (flag: Bool, to: Element): Void{})
    //@:overload(function (flag: Bool, to: JQuery): Void{})
    @:overload(function (template: Template, to: String): Void{})
    @:overload(function (template: Template, to: Element): Void{})
    //@:overload(function (template: Template, to: JQuery): Void{})
    @:overload(function (): Void{})
    static function unlink(flag: Bool, to: String) : Void;

    @:overload(function (object: {}): ObjectObservable{})
    static function observable(array: Array<Dynamic>) : ArrayObservable;

    @:overload(function (object: {}, ?path: String, myHandler: ObservableEvent -> ObservableEventArgs -> Void): {}{})
    static function observe(array: Array<Dynamic>, myHandler: ObservableEvent -> ObservableEventArgs -> Void) : {};

    @:overload(function (array: Array<Dynamic>): {}{})
    @:overload(function (object: {}): {}{})
    @:overload(function (object: {}, ?path: String, myHandler: ObservableEvent -> ObservableEventArgs -> Void): {}{})
    static function unobserve(array: Array<Dynamic>, myHandler: ObservableEvent -> ObservableEventArgs -> Void): {};
}

typedef TemplateOptions = {
    markup: String,
    ?converters: { },
    ?helpers: { },
    ?tags: { }
}


typedef Template = {
    var markup(default, never): String;

    function render(?data: {}, ?helpersOrContext: Dynamic): String;

    @:overload(function (to: Element, from: {}, ?context: {}): Dynamic{})
    //@:overload(function (to: JQuery, from: {}, ?context: {}): Dynamic{})
    function link(to: String, from: {}, ?context: {}): Dynamic;

    @:overload(function (to: Element): Void{})
    //@:overload(function (to: JQuery): Void{})
    function unlink(to: String): Void;
}

typedef TagCtx = {
    var markup(default, never): String;
    var args(default, never): Array<Dynamic>;
    var params(default, never): String;
    var props(default, never): Dynamic;
    var content(default, never): Template;
    var views(default, never): Dynamic;
    function render(?data: {}, ?helpersOrContext: Dynamic): String;
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
    var target(default, never): { }; // Object or Array<Dynamic>
    var data(default, never): { };   // JsViews metadata
}

typedef ObservableEventArgs = {
    var change(default, never): ObservableEventType;

    var path(default, never): Null<String>;      // object / set
    var value(default, never): Null<Dynamic>;    // object / set
    var oldValue(default, never): Null<Dynamic>; // object / set
    var index(default, never): Null<Int>;             // array / insert, remove, move
    var items(default, never): Null<Array<Dynamic>>;  // array / insert, move
    var numToRemove(default, never): Null<Int>;       // array / remove
    var oldIndex(default, never): Null<Int>;          // array / move
    var oldItem(default, never): Null<Dynamic>;       // array / refresh
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