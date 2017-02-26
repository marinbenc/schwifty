{
"date": "18-02-2016",
"title": "About"
}


This is a static site generator made for blogs, written in Swift.

It's made for marinbenc.com and I don't guarantee it will work for your purposes, but feel free to use it if you want to.

## Usage

### 1. Adding a new post

Posts are located in the `Resources/Posts` directory. Each post is a markdown formatted file with a JSON on top.

The JSON **has** to contain a date string formatted as `dd-MM-yyyy` and a title string.

Here's an example of a post file

```
{
"date": "18-02-2016",
"title": "About"
}

The rest of this file (like this sentence) is the content of the post written in markdown.
```

Once you add a new post file to the directory, simply re-run the project and it will show up.

The normalized title of the post will become the URL for that post, so going to `youblog.com/title-of-your-post` will give you the post page.

### 1. Adding a new page

Adding pages works the same as adding posts, except you add files to the `Resources/Pages` directory. The navigation bar will update once you re-run the project with your new page.
