class Generator

  GREEN='\033[0;32m'
  RED='\033[0;31m'
  NC='\033[0m'
  CREATED = "#{GREEN}created#{NC}"
  ADDLINE = "#{GREEN}added#{NC}"
    
  def run(array)
    if array[0] == "new"
      new(array[1])
    else
      puts "unknown command"
    end
  end

  def new(project)
    # print "What would you like to call your project? "
    # project = gets.strip
    pdir = "./#{project}"
    add_folder(pdir)
    add_folder("#{pdir}/bin")
    add_file("#{pdir}/bin/#{project}")
    add_line("#!usr/bin/env ruby", "#{pdir}/bin/#{project}")
    add_folder("#{pdir}/lib")
    initialize_gemfile(pdir)
  end

  def add_file(path)
    system("touch #{path}")
    system("printf '#{CREATED} #{path}\n'")
  end

  def add_folder(path)
    system("mkdir #{path}")
    system("printf '#{CREATED} #{path}\n'")
  end

  def add_line(text, path)
    system("echo '#{text}' >> #{path}")
    system("printf '#{ADDLINE} #{text} >> #{path}\n'")
  end

  def initialize_gemfile(path)
    system("cd #{path} && bundle init")
    system("printf '#{CREATED} #{path}/Gemfile\n'")
    system("echo '\ngroup :test, :development do' >> #{path}/Gemfile")
    add_line('  gem "pry"', "#{path}/Gemfile")
    system("echo 'end' >> #{path}/Gemfile")
    system("echo '\ngroup :test do' >> #{path}/Gemfile")
    add_line('  gem "rspec"', "#{path}/Gemfile")
    system("echo 'end' >> #{path}/Gemfile")
    system("cd #{path} && bundle install && rspec --init")
    add_line('--format d', "#{path}/.rspec")
    add_line('--color', "#{path}/.rspec")
  end

end