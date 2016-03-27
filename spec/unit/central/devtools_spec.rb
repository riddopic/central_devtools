# encoding: UTF-8

describe Central::Devtools do
  describe '.project' do
    specify do
      expect(Central::Devtools.project).to equal(Central::Devtools::PROJECT)
    end
  end

  describe '.init' do
    specify do
      expect(Central::Devtools::Project::Initializer::Rake).to receive(:call)
      expect(Central::Devtools.init).to be(Central::Devtools)
    end
  end
end
