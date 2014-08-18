require_relative 'bocelli'

module Bocelli::Module::Foo
  extend Bocelli::Module::Base

  on 'test' do
    out 'this is a test!'
  end

  on /^foo/ do
    out 'foo' * (rand(5) + 1)
  end
end

module Bocelli::Module::Bar
  extend Bocelli::Module::Base

  on /^bar+$/ do
    out 'bar' * (rand(5) + 1)
  end

  on /^baz+$/i do
    out 'baz' * (rand(5) + 1)
  end
end

class TestBot < Bocelli::Base
  register Bocelli::Module::Foo
  register Bocelli::Module::Bar

  on 'rand' do
    out rand(100)
  end

  on 'current' do
    out '%s %s' % [@bocelli[:str].inspect, @bocelli[:route].inspect]
  end
end

TestBot.configure('chat.freenode.net', 6667, 'bocelli%03d' % rand(1000))
TestBot.connect do
  join '##omp'
end

TestBot.run
