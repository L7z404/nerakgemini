defmodule NerakgeminiWeb.Fields.TrixField do
  use Backpex.Field

  @impl Backpex.Field
  def render_value(assigns) do
    ~H"""
    <div class={[
      @live_action in [:index, :resource_action] && "truncate",
      @live_action == :show && "overflow-x-auto trix-content"
    ]}>
      {raw(@value || "")}
    </div>
    """
  end

  @impl Backpex.Field
  def render_form(assigns) do
    ~H"""
    <div>
      <Layout.field_container>
        <:label align={Backpex.Field.align_label(@field_options, assigns, :top)}>
          <Layout.input_label for={@form[@name]} text={@field_options[:label]} />
        </:label>
        <div phx-update="ignore" id={"#{@form[:id].value}-trix-wrapper"} phx-hook="Trix">
          <Backpex.HTML.Form.input type="textarea" field={@form[@name]} hide_errors />
        </div>
      </Layout.field_container>
    </div>
    """
  end
end
