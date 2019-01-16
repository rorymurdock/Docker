// Setup logging
const winston = require('ww-logger')

var Slack = require('ww-slack');
var Splunk = require('ww-splunk');

const SlackService = new Slack()
const SplunkService = new Splunk()

const SyslogServer = require("ww-syslog");
const server = new SyslogServer();

server.on("message", (value) => {

    // Set regex pattern to extract the message from syslog format
    var re1 = new RegExp('^[^\\]\\n]*\\]\\s+(.+)')
    message = value.message.match(re1)[1]

    // Send message to slack
    SlackService.sendMessage(message, function(err, data){
        if (err){
            winston.log('error', 'Unable to send message to Slack')
        }
        else{
            winston.log('info', 'Message sent to Slack: '+message)
        }
    });

    // Send event to Splunk
    // Format for Splunk
    var message = {
        // 'event': filtered[1],
        'event': message,
        'source': value.protocol
    }
    SplunkService.sendEvent(message, function(err, data){
        if (err){
            winston.log('error', 'Unable to send event to Splunk')
        }
        else{
            winston.log('info', 'Event sent to Splunk: '+message)
            winston.log('info', 'Event sent to Splunk: '+value.message.match(re1)[1])
        }
    });
    
});

server.start();