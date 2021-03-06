chromedriver = require 'chromedriver'
child process = require 'child_process'

start (options, started) =
    port = options.port || 9515
    log path = options.log path || './chromedriver.log'

    child = child process.spawn (chromedriver.path) [
        "--port=#(port)"
        "--log-path=#(log path)"
    ]
    child.on 'error' @(data)
        console.log ("ERROR", data)

    child.stdout.on 'data' @(data)
        if (data.to string().index of "Starting ChromeDriver" > -1)
            child.stop (stopped) =
                child.on 'close'
                    stopped (null)

                child.kill()

            started (null, child)

    child.on 'exit' @(status)
        if (status)
            console.log "chromedriver exited with code #(status)"

    process.on 'exit'
        child.kill()

    process.on 'SIGINT'
        child.kill()

exports.start! (options) = start! (options || {})
