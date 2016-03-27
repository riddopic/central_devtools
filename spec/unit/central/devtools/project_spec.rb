# encoding: UTF-8

RSpec.describe Central::Devtools::Project do
  let(:object) { described_class.new(Central::Devtools.root) }

  describe '#init_rspec' do
    subject { object.init_rspec }

    it 'calls the rspec initializer' do
      expect(Central::Devtools::Project::Initializer::Rspec)
        .to receive(:call).with(Central::Devtools.project)
      expect(subject).to be(object)
    end
  end

  {
    devtools: Central::Devtools::Config::Devtools,
    flay: Central::Devtools::Config::Flay,
    flog: Central::Devtools::Config::Flog,
    reek: Central::Devtools::Config::Reek,
    mutant: Central::Devtools::Config::Mutant,
    rubocop: Central::Devtools::Config::Rubocop,
    yardstick: Central::Devtools::Config::Yardstick
  }.each do |name, klass|
    describe "##{name}" do
      subject { object.send(name) }

      specify { should eql(klass.new(Central::Devtools.root.join('config'))) }
    end
  end

  describe '#spec_root' do
    subject { object.spec_root }

    specify { should eql(Central::Devtools.root.join('spec')) }
  end
end
