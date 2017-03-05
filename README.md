
This is a static site generator made for blogs, written in Swift.

It's made for http://marinbenc.com and I don't guarantee it will work for your purposes, but feel free to use it if you want to.

## Usage

### 1. Adding a new post

Posts are located in the `Resources/Posts` directory. Each post is a markdown formatted file with a JSON on top.

The JSON **has** to contain a date string formatted as `dd-MM-yyyy` and a title string.

Here's an example of a post file

```
{
"date": "18-02-2016",
"title": "About",
"isFeatured": true
}

The rest of this file (like this sentence) is the content of the post written in markdown.
```

Once you add a new post file to the directory, simply re-run the project and it will show up.

You can also add an `isFeatured` `bool` key in the JSON (by default it's `false`), which will add it to the featured posts list if `true`. **This key is optional.**

The normalized title of the post will become the URL for that post, so going to `youblog.com/title-of-your-post` will give you the post page.

### 2. Adding a new page

Adding pages works the same as adding posts, except you add files to the `Resources/Pages` directory. The navigation bar will update once you re-run the project with your new page.

## License: MIT

Copyright (c) 2017 Marin Benčević

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
