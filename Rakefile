require 'net/http'

namespace :moko do
    task :fetch do
        FileUtils.mkdir_p "moco" 
        FileUtils.mkdir_p 'resources'
        FileUtils.mkdir_p 'conf'

        unless File.exist? "moco/moco-runner-standalone.jar" then
            puts "Downloading moco-runner..."
            Net::HTTP.start("repo1.maven.org") do |http|
                resp = http.get("/maven2/com/github/dreamhead/moco-runner/0.9.1/moco-runner-0.9.1-standalone.jar")
                open("moco/moco-runner-standalone.jar", "wb") do |file|
                    file.write(resp.body)
                end
            end
            puts "moco-runner is up-to-date"
        end
    end

    desc "init moko, download the underlying moco"
    task :init => :fetch do
    end

    desc "generate all conf and resources"
    task :setup do
        ruby "moko.rb"
    end

    desc "run the moco server"
    task :server => [:init, :setup] do
        sh "java -jar ./moco/moco-runner-standalone.jar start -p 12306 -c conf/moko.conf.json"
    end
end
