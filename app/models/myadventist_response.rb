class MyadventistResponse

  attr_reader :success, :status, :data

  def initialize(response)
    @success = response.success?
    @status = response.status
    @data = JSON.parse(response.body).transform_keys { |key| key.underscore.to_sym } rescue {}
  end

  def success?
    @success
  end
end