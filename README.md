JsViews-Haxe
============

JsViews-Haxe is a haxe externs for [JsViews](http://www.jsviews.com/).

* Haxe 3.1+
* JsViews V1.0 commit counter: 52 (Beta Candidate)

Usage
-----
```haxe
import js.jsviews.JsViews;

class Main {
	static function main() {
		var template = JsViews.templates("<div>{{name}}</div>");
		var rendered = template.render({name: "terurou"});
		trace(rendered);
	}
}
```

Licence
-------
MIT Licence