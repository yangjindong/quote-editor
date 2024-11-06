class QuotesController < ApplicationController
  before_action :set_quote, only: %i[ show edit update destroy ]

  # GET /quotes or /quotes.json
  def index
    @quotes = current_company.quotes.ordered
  end

  # GET /quotes/1 or /quotes/1.json
  def show
    @line_item_dates = @quote.line_item_dates.includes(:line_items).ordered
  end

  # GET /quotes/new
  def new
    @quote = Quote.new
  end

  # GET /quotes/1/edit
  def edit
  end

  # POST /quotes or /quotes.json
  def create
    @quote = current_company.quotes.build(quote_params)

    respond_to do |format|
      if @quote.save
        format.html { redirect_to @quote, notice: "Quote was successfully created." }
        format.json { render :show, status: :created, location: @quote }
        format.turbo_stream { flash.now[:notice] = "Quote was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @quote.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /quotes/1 or /quotes/1.json
  def update
    respond_to do |format|
      if @quote.update(quote_params)
        format.html { redirect_to @quote, notice: "Quote was successfully updated." }
        format.json { render :show, status: :ok, location: @quote }
        format.turbo_stream { flash.now[:notice] = "Quote was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @quote.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quotes/1 or /quotes/1.json
  def destroy
    @quote.destroy!

    respond_to do |format|
      format.html { redirect_to quotes_path, status: :see_other, notice: "Quote was successfully destroyed." }
      format.json { head :no_content }
      format.turbo_stream { flash.now[:notice] = "Quote was successfully destroyed." }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_quote
    @quote = current_company.quotes.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def quote_params
    params.expect(quote: [ :name ])
  end
end
