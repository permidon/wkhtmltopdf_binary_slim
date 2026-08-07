require 'minitest/autorun'

class WithDockerTest < Minitest::Test
  SETUP = `docker compose build --no-cache`

  def test_debian_12
    test_on_docker with: 'debian_12'
  end

  def test_amzn_2023
    test_on_docker with: 'amzn_2023'
  end

  private

  def test_on_docker(with:)
    assert_match(/wkhtmltopdf 0\.12\.6(.1)? \(with patched qt\)/, `docker compose run --rm #{with}`.strip)
  end
end
