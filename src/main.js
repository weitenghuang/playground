"use strict";

// Copyright (c) 2012 Mark Cavage. All rights reserved.

var fs = require('fs');
var path = require('path');

var bunyan = require('bunyan');
var getopt = require('posix-getopt');
var restify = require('restify');

// In true UNIX fashion, debug messages go to stderr, and audit records go
// to stdout, so you can split them as you like in the shell
var LOG = bunyan.createLogger({
    name: "HelloWorld",
    streams: [
        {
            level: (process.env.LOG_LEVEL || 'info'),
            stream: process.stderr
        },
        {
            // This ensures that if we get a WARN or above all debug records
            // related to that request are spewed to stderr - makes it nice
            // filter out debug messages in prod, but still dump on user
            // errors so you can debug problems
            level: 'debug',
            type: 'raw',
            stream: new restify.bunyan.RequestCaptureStream({
                level: bunyan.WARN,
                maxRecords: 100,
                maxRequestIds: 1000,
                stream: process.stderr
            })
        }
    ],
    serializers: restify.bunyan.serializers
});


///--- Mainline

(function main() {

    var server = restify.createServer({
        name: "HelloWorld",
        log: LOG
    });

    server.get('/', function root(req, res, next) {
        var routes = [
            'GET     /',
            'POST    /todo',
            'GET     /todo',
            'DELETE  /todo',
            'PUT     /todo/:name',
            'GET     /todo/:name',
            'DELETE  /todo/:name'
        ];
        res.send(200, routes);
        return next(false);
    });

    server.on('after', restify.auditLogger({
        body: true,
        log: bunyan.createLogger({
            level: 'info',
            name: 'todoapp-audit',
            stream: process.stdout
        })
    }));

    // At last, let's rock and roll
    server.listen(3000, function onListening() {
        LOG.info('listening at %s', "3000");
    });
})();
