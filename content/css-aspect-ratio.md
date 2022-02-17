---
{
  slug: 'css-aspect-ratio',
  title: 'Using Aspect Ratio in CSS',
  tags: ['web'],
  publishDate: '2018-09-12',
  description: 'The aspect ratio of an element describes the proportional relationship between its width and its height.',
}
---

The aspect ratio of an element describes the proportional relationship between its width and its height.
Depending on the device you are using to access a responsive web page the content may be a different size. The same content will most likely need to keep its
aspect ratio whatever the device so that the content makes sense and looks good. It is all about looking good.

In front end web development there are different ways to determine the aspect ratio of an element. These include defining height/width in ems and defining the  
font-size of a given element and using viewport width, vw to style responsively.

There are many mixins for sass, which make light work of aspect ratios.
This post is to briefly explain a way to achieve a scalable image using the :before pseudo class and parent and its child element.

Let's use two separate div elements, one called _.image_, and inside of that another, _.image\_\_content_.

The goal here is to position .image 'relatively' so that it will take on a parental role.
We want our _.image\_\_content_ to completely fill _.image_, which can be done by telling _.image\_\_content_ to have a ‘position: absolute’ and telling it to begin at each side of the _.image_ div.
Next we will add a background-image too.
We will make our _.image:before_ class have ‘width: 100%’ and instruct it that it has content. Both our _.image\_\_content_ and _:before_ class need to be ‘block’ elements.
By adding padding-top to the _.image:before_, we determine the height of _.image\_\_content_ and its background-image.

All that is left to do is to set the width of _.image_ now that _.image\_\_content_ fills it and is set to the correct aspect-ratio.
See below for a working example &darr. :point_down:

**HTML**

```html
<div class="image">
  <div class="image__content"></div>
</div>
```

**CSS**

```css
.image {
  position: relative;
  width: 40%;
}

.image:before {
  display: block;
  width: 100%;
  content: '';
  padding-top: 77%;
  /*padding-top = height/width x 100  */
}

.image__content {
  display: block;
  position: absolute;
  top: 0;
  bottom: 0;
  left: 0;
  right: 0;
  background-image: url('https://lh3.google.com/u/0/d/1M2D3jyM95cnEho6Q7RK6PAy7-QD5PQHg=w1920-h956-iv1');
  background-size: contain;
  background-repeat: no-repeat;
  background-position: center;
}
```
