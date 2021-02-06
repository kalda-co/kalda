# Blog Post Creation

## Technical Documentation

#### 23.01.21 - Al Dee

## Prerequisites

You will first need to have installed the Kalda-co/Kalda repository on your computer. In order to do this, you will need a Github account and to have been granted access to the Github Repository, by one of the administrators.

1. If you don't have one already, make a github account [here:](https://github.com/)
2. Give your github account username to an administrator, and enable 2-factor authentification on your account.[Guide here.](https://docs.github.com/en/github/authenticating-to-github/configuring-two-factor-authentication)

## Clone the project locally

You will need to have created an SSH key and added it to your GitHub account
before cloning the repo. See the [GitHub documentation][gh-ssh] for instructions.

[gh-ssh]: https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/connecting-to-github-with-ssh

```sh
cd to/directory/where/you/keep/your/projects
git clone git@github.com:kalda-co/kalda.git
cd kalda
```

VSCode is the editor that we reccomend. You can download it [here.](https://code.visualstudio.com/download)

## File locations

![screen shot of file system](/images/blog-docs-image-1.jpg)

Above is a screen-shot of what your file directory will look like (approximately) after you open the `kalda` folder in VSCode. On the left, circled in green, you will see the `posts` folder. Posts are stored in a folder corresponding year folder and month folder. If the correct month does not exist, create it. For example:

```sh
# Posts created in Januray 2021 go here:
kalda/posts/2021/jan
```

Your article copy will go here.
**_Note the naming convention; no spaces, use hyphens not underscores, no symbols except alphanumeric (a-z, 0-9), all words lower case, use hypens for spaces. (noy underscores)._**
Circled in blue, you will see the folder where your images should go. Images will be covered below.

## File name and structure

Your title should be the same as the filename, but where you use capitalisation in your title, use lowercase in the file name. Where you use spaces, replace them with hyphens and ignore any other punctuation. If your title is very long, use the first 5 or 6 words, enough to get a gist of the content.
_This is important for SEO reasons, (as well as searchability, convention, compatibility and best practice) the title of your article._
If your filename is incorrectly formatted, your blog post will not load/be found.
**_Note the naming convention; no spaces, use hyphens not underscores, no symbols except alphanumeric (a-z, 0-9), all words lower case, use hypens for spaces. (noy underscores)._**

# 1. STEP ONE Create File

1. First create a file in the correct location, named as explained above. The file extension is `.md` which stands for markdown (like `.txt` stands for a text file.)

#### Example

Article title:
Do I have to be LGBTQIA+ to use Kalda?

Create a file with the name of your article, and the extension `.md` in the folder `kalda/posts/YYYY/mnth`
example:
In `kalda/posts/2021/jan` create `do-i-need-to-be-lgbtqia.md`

# 2. STEP TWO Write it

1. Paste this at the top of the file:

```md
%{
title: "Title",
author: "Al Dee",
tags: ["tag-one", "tag-two", "tag-three"],
description: "This description will not appear on the page but can contain search terms",
date: "2021-01-11"
}

---

# Title

content...
```

Then you change the bits in quotation marks, and the title and the content, see the example below:

#### Example:

```md
%{
title: "Do I need to be LGBTQIA+ to use Kalda?",
author: "Al Dee",
tags: ["LGBTQIA", "Kalda", "inclusion"],
description: "This article answers the questions: Why do you have to be LGBTQIA+?; Is Kalda for everyone?; Why isn't Kalda for everyone?; Why do you need to be invited to Kalda?; What if I don't have friends who are LGBTQIA+?; What if I am not out?; What if I need Kalda but have no one to invite me?",
date: "2021-02-04"
}

---

# Do I Need To Be LGBTQIA+ To Use Kalda?

> Q I don't identify as LGBTQIA+, can I use Kalda?

_A yes, you canbecause a kaldan who identfiy as LGBTQIA+ has reccommednded you..._
```

# 3. STEP THREE Writing an article

3. Ensure that you change the areas between the quote marks in your article header. It is particularly important to check you have the correct date and title. You can add more tags.

4. Your title goes beneath the three hyphens and then the rest of the article follows.

You will write your articles in Markdown. If you do not already know how to use Markdown there is a handy guide [here](https://www.markdownguide.org/basic-syntax/)
To preview your copy in VSCode, do `Ctrl+Shift+v` or `Ctrl+V` on a PC/Linux, and `Command+V` on a Mac

# 4. STEP FOUR Adding Images

Your images should live in this folder:
`kalda/assets/static/images/`

### Image compression

Large images make page loading slow, you should make sure that your image is optimised for a web page. You can learn more about this [here](https://web.dev/fast/#optimize-your-images), or learn to compress your images from the command line [here](https://css-tricks.com/converting-and-optimizing-images-from-the-command-line/) Your image editor should have some compression options

### Image alignment in markdown

Normal markdown image tags don’t allow for any alignment properties. They kind of go where they want. They will be the dimension you upload - so keep them to a max of 400px wide, for mobile.

```md
<!-- No alignment options -->

![Short Description](/images/my_example_image.jpg)
```

Luckily, we can use html image tags to improve things, by changing the position and the width and height:

Left alignment
This is the code you need to align images to the left:

```md
<img align="left" width="100" height="100" src="/images/logo.jpg">
```

Right alignment
This is the code you need to align images to the right:

```md
<img align="right" width="100" src="/images/logo.jpg">
Center alignment example
```

Wrap images in a p or div to center.

```md
<p align="center">
  <img width="460" height="300" src="/images/logo.jpg">
</p>
```

Your image will be stretched to fit the width and height you specify so if you want to preserve the aspect ratio of the image then you need to reflect that in your dimensions OR chose only one (ie width OR height)

<!-- TODO -->

If you can write css you can give the image an id, (make it something that will be unique, like 'beach-image-333'), and style that id at the end of the css file:
`kalda/assets/css/blog.css`
Do not delete any preexisting styles or put any styles on anything other than your image. Because you are putting your styles on an id at the bottom of the css file it will overwrite other styles.

# 5. STEP FIVE Saving, uploading and viewing your article.

### Viewing work locally

If you have followed the local developer setup you can view the work in progress by starting the server and navigating to `localhost:4000/blog/NAME-OF-YOUR-BLOG-POST`
Start the server like this:

```sh
npm start
```

### Uploading work to Github

1. In your terminal/shell create a Git branch:

```sh
git checkout -b "my-initials-my-branch-name"
# Your command prompt will now look like this:
> ~/.../kalda [my-initials-my-branch-name] $
```

2. Commit your work:

```sh
git add --all
git commit -m "BLOG POST NAME BY YOUR NAME"
git push --set-upstream origin my-initials-my-branch-name
```

3. Ask for someone on the Dev team to review your code by making a Pull Request

[https://github.com/kalda-co/kalda/pull/new/my-initials-my-branch-name](https://github.com/kalda-co/kalda/pulls)
It is a good idea to message them on Slack too!

<!-- TODO
meta tag optimisation for socials
https://css-tricks.com/essential-meta-tags-social-media/
-->
