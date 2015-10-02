--- 
layout: post
title: Almost building an image resizing microservice with AWS Lambda and API Gateway
description: Experimenting with AWS Lambda and API Gateway to build a url
based image resizer. Spoiler: you can't, yet.
published: true
---

A couple days ago, I read this incredible article about [running CRISPR
searches on DNA using AWS Lambda](http://benchling.engineering/crispr-aws-lambda/?hn).
Easily one of the coolest engineering blog posts I've read in a while.
I started thinking about other uses for this kind of architecture, and
set out to experiment with on an idea today - building an image
processing service on top of Lambda.

This is an area near and dear to my heart after my time spent converting
Vox Media's publishing platform to use [Thumbor](https://github.com/thumbor/thumbor) - a very full featured Python based image processing service.
I thought it would be pretty neat if you could run such a service
without having to manage any servers - run it all of Cloudfront
and Lambda. The goal would be totally URL based API to the
service, easy to setup and even easier to keep running.

Looking at the AWS Lambda documentation, I learned that if you want to
interact with Lambda over HTTP, you need to go through Amazon API
Gateway. This was a new service to me, but the pitch made sense -
configure an API with them, and they'll take care of
scaling, caching, logging, monitoring, throttling, managing different
environments like staging and production.

Naturally, there is a ton of product specific jargon to API Gateway, but
[the docs have a walk through to link up with Lambda](http://docs.aws.amazon.com/lambda/latest/dg/gs-amazon-gateway-integration.html)
that was pretty straightforward. After getting the 'Hello World' going, I
started hacking away on a proof of concept to provide an image url, height and width, and get a resized image in response.
Here's what I ended up with:

{% highlight javascript %}var im = require('imagemagick');
var im = require('imagemagick');
var http = require('http');
var fs = require('fs');
var url = require('url');
var query = require('querystring');

var postProcessResource = function(resource, fn) {
    var ret = null;
    if (resource) {
        if (fn) {
            ret = fn(resource);
        }
        try {
            fs.unlinkSync(resource);
        } catch (err) {
            // Ignore
        }
    }
    return ret;
};

exports.handler = function(event, context) {
    var params = query.parse(event["query-params"]);
    params.img = params.img || 'http://i.imgur.com/FELsQ9f.png';
    params.width = params.width || 100;

    // Download the original file for editing
    // will this explode because of format?
    var originalFilePath = "/tmp/" + new Date().getTime();
    var resizedFilePath = originalFilePath + '-resized';

    var originalFile = fs.createWriteStream(originalFilePath);
    // lol error handling
    var request = http.get(params.img, function(response) {
        response.pipe(originalFile);
        response.on('end', function() {
            var resizeParams = {
                srcPath: originalFilePath,
                dstPath: resizedFilePath,
                width: params.width
            }
            try {
                im.resize(resizeParams, function(err, stdout, stderr) {
                    if (err) {
                        throw err;
                    } else {
                        console.log('Resize operation completed successfully');
                        context.succeed(
                            postProcessResource(resizedFilePath, function(file) {
                                return {
                                    body: fs.readFileSync(file).toString('base64'),
                                    header: {
                                        'Content-Type': 'image/jpeg'
                                    }
                                };
                            })
                        );
                    }
                });
            } catch (err) {
                console.log('Resize operation failed:', err);
                context.fail(err);
            }
        });
    });
};
{% endhighlight %}
_Apologies for any nightmares this prototype code causes you ._

Turns out, this dream is _very similar_ to a [demo the AWS Lambda General
Manager gave recently](https://aws.amazon.com/blogs/compute/microservices-without-the-servers/), where he
built image resizing service on top of Lambda and API Gateway.
I came across this post after Googling a Lambda blueprint called
'image-processing-service', and it provided a great start for what I was
trying to do.

It _did_ seem a little odd to me images were being returned in
base64 encoding, even for the web demo. I rolled with it since Lambda is
basically returning JSON, and you can decode from base64 in the
'Integration Response' section of API Gateway.

<img src='//i.imgur.com/0o2wNOt.png' style='width:100%'>
_Integration Response configuration_

At this point, this experiment kind of fell apart. I had the response
body returning the right thing, but API Gateway _really_ wants you to
return JSON, so the default Content-Type header is application/json.
Naturally, browsers aren't going to load images like that, so I did some
digging on setting response headers in Lambda. Turns out, this is impossible:

    API Gateway does not currently support mapping from the integration response body
    to the response headers, but we are looking to add support for this in the future.

_[jackko@AWS on September 25, 2015](https://forums.aws.amazon.com/thread.jspa?messageID=676533)_

Which is a pretty big blocker for an image resizing service. Different
headers are going to be necessary for JPEG vs PNG vs WEBP.
API Gateway is very REST and JSON oriented, so what I'm trying to do
is probably outside the design expectations.
API Gateway is a new product and seems to be [iterating on feedback](https://blog.hiramsoftware.com/blog/day-two-aws-api-gateway/index.html)
pretty quickly, but for now, this is a blocker for this project.
