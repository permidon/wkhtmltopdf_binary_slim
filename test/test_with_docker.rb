require 'minitest/autorun'

def macos?
  ENV['RUNNER_OS'] && ENV['RUNNER_OS'] == 'macOS'
end

def arm?
  ENV['ARM']
end

class WithDockerTest < Minitest::Test
  SETUP = begin
    `docker-compose build --no-cache` unless macos?
  end

  def test_centos_8
    test_on_x86 with: 'centos_8'
  end

  def test_debian_12
    test_on_x86_and_arm with: 'debian_12'
  end

  def test_amazonlinux_23
    test_on_x86 with: 'amazonlinux_23'
  end

  private

  def test_on_x86(with:)
    test_on_docker(with: with) if !macos? && !arm?
  end

  def test_on_x86_and_arm(with:)
    test_on_docker(with: with) unless macos?
  end

  def test_on_docker(with:)
    assert_match(/wkhtmltopdf 0\.12\.6(.1)? \(with patched qt\)/, `docker-compose run --rm #{with}`.strip)
  end
end
