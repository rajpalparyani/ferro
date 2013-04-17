require 'crxmake'

#https://github.com/documentcloud/backbone/raw/master/backbone.js
#https://github.com/douglascrockford/JSON-js/raw/master/json2.js

task :default => :compile

task :watch do
  exec 'coffee -cw -o extension/js/ src/coffee/'
  exec 'sass --watch src/sass/options.sass:extension/options.sass'
  exec 'sass --watch src/sass/popup.sass:extension/popup.sass'
  exec 'coffeecup -w -o extension/js/ src/coffeecup/options.coffee'
end

task :sass do
  #  `node_modules/coffeecup/bin/coffeecup -fw -o extension/js/ src/coffeecup/options.coffee &`
  `sass --watch src/sass/:extension/css/`
end

task :compile => [:options_template, :options_app,  :popup, :background, :sass]

task :background do
  compile([],['background'],{output: 'background'})
end

task :options_template do
  compile(
          [],
          [
           'init',
           'commands'
          ],
          {
            ccup: 'options'
          }
          )
end

task :popup do
  compile(
          [
            'jquery',
            'underscore',
            'backbone',
            'backbone-localStorage',
            'coffeecup'
          ],
          [
            'init',
            'model',
            'keys',
            'commands',
            'underscore-extensions',
            'main-logic',
            'template-loader'
          ],
          {
            ccup_js: 'popup',
            output: 'popup'
          }
  )
end

task :options_app do
  compile(
          [
            'jquery',
            'underscore',
            'backbone',
            'backbone-localStorage',
            'coffeecup'
          ],
          [
           'model',
           'options-backbone'
          ],
          {
            output: 'options'
          }
          )
end

def compile js, coffee, opts = {}
  if opts[:ccup] or opts[:js]

    unless js.empty?
      `cat vendor/#{js[0]}.js >> tmp2.js`
      `echo "\n" >> tmp2.js`
      `echo "var _ = require('underscore');" >> tmp2.js` if opts
      `echo "\n" >> tmp2.js`
      js[1..-1].each do |file|
        `cat vendor/#{file}.js >> tmp2.js`
      end
    end


    opts[:head] ||= ""
    opts[:head] << "
window = {}
f = {}
"

    `echo "#{opts[:head]}" > tmp.coffee`
    `cat src/coffee/#{coffee[0]}.coffee >> tmp.coffee`
    coffee[1..-1].each do |file|
      `echo "\n" >> tmp.coffee`
      `cat src/coffee/#{file}.coffee >> tmp.coffee`
    end
    `echo "\n" >> tmp.coffee`
    `cat src/coffeecup/#{opts[:ccup] or opts[:js]}.coffee >> tmp.coffee`

    if opts[:js]
      `coffee -bc tmp.coffee`
      `cat tmp.js >> tmp2.js`

      `echo "#{pre}" > tmp.js`
      `cat tmp2.js >> tmp.js`

      # `rm tmp.js`
      # `rm tmp.coffee`
#      `mv tmp.js extension/js/#{opts[:js]}`
    else
      `node_modules/coffeecup/bin/coffeecup tmp.coffee`
      `mv tmp.html extension/#{opts[:ccup]}.html`
    end
    # if opts[:use_node]
    #   `coffee -bc tmp.coffee`
    #   `node tmp.js`
    # else
    # end
#    `rm tmp.coffee`

  else
    `cat src/coffee/#{coffee[0]}.coffee > tmp.coffee`
    coffee.each do |file|
      `echo "\n" >> tmp.coffee`
      `cat src/coffee/#{file}.coffee >> tmp.coffee`
    end
    if opts[:ccup_js]
      `echo "\n" >> tmp.coffee`
      `cat src/coffeecup/#{opts[:ccup_js]}.coffee >> tmp.coffee`
    end
    `coffee -bc tmp.coffee`
#    `rm tmp.coffee`

    if ENV['env'] == 'production'
      js.each do |s|
        s << '.min'
      end
    end

    `echo "#{opts[:pre]}" > tmp2.js`

    unless js.empty?
      `cat vendor/#{js[0]}.js >> tmp2.js`
      `echo "\n" >> tmp2.js`
      js[1..-1].each do |file|
        `cat vendor/#{file}.js >> tmp2.js`
      end
      `echo "#{opts[:post]}" >> tmp2.js`
    end

    # if opts[:ccup]
    #   `node_modules/coffeecup/bin/coffeecup --js src/coffeecup/#{opts[:ccup]}.coffee`
    #   `cat src/coffeecup/#{opts[:ccup]}.js >> tmp2.js`
    #   `rm src/coffeecup/#{opts[:ccup]}.js`
    # end

    `cat tmp.js >> tmp2.js`

    opts[:ext] ||= 'js'
    opts[:dest] ||= 'extension/js'
    `mv tmp2.js #{opts[:dest]}/#{opts[:output]}.#{opts[:ext]}`
  end
end

def exec cmd
  Thread.new(cmd) do |tcmd|
    IO.popen tcmd do |fd|
      until fd.eof?
        puts fd.readline
        sleep 10
      end
    end
  end
end

task :vendor do
  get 'https://raw.github.com/joshaven/string_score/master/string_score.js', 'string-score.js'
  get 'http://code.jquery.com/jquery-1.9.1.min.js', 'jquery.js'
  get 'http://documentcloud.github.com/underscore/underscore.js'
  get 'https://raw.github.com/jeromegn/Backbone.localStorage/master/backbone.localStorage.js', 'backbone-localstorage.js'
  get 'http://epeli.github.com/underscore.string/lib/underscore.string.js'
  get 'http://documentcloud.github.com/backbone/backbone.js'
  get 'https://raw.github.com/gradus/coffeecup/master/lib/coffeecup.js'
end


def get url, name = nil
  name = url[url.rindex('/')+1..-1] unless name
  `wget #{url} -O vendor/#{name}`
end

task :make do
  CrxMake.make(
               :ex_dir => "./extension",
               :pkey   => "~/.ssh/ferro.pem",
               :crx_output => "./ferro.crx",
               :verbose => true,
               :ignorefile => /~$/,
#               :ignoredir => /\.(?:svn|git|cvs)/
               )
end
