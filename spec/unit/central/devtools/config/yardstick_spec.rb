# encoding: UTF-8

RSpec.describe Central::Devtools::Config::Yardstick do
  let(:object) { described_class.new(Central::Devtools.root.join('config')) }

  describe '#options' do
    subject { object.options }

    specify do
      should eql(
        'threshold' => 100,
        'rules' => nil,
        'verbose' => nil,
        'path' => nil,
        'require_exact_threshold' => nil
      )
    end
  end
end
