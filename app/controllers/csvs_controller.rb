class CsvsController < ApplicationController
  # GET /csvs
  # GET /csvs.json
  def index
    @csvs = Csv.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @csvs }
    end
  end

  # GET /csvs/1
  # GET /csvs/1.json
  def show
    @csv = Csv.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @csv }
    end
  end

  # GET /csvs/new
  # GET /csvs/new.json
  def new
    @csv = Csv.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @csv }
    end
  end

  # GET /csvs/1/edit
  def edit
    @csv = Csv.find(params[:id])
  end

  # POST /csvs
  # POST /csvs.json
  def create
    @csv = Csv.new(params[:csv])

    send_data @csv.csv_from_xml, filename: "import.csv", type: 'text/csv', disposition: "attachment" and return
    #send_data @csv.csv_from_html, filename: "import.csv", type: 'text/csv', disposition: "attachment" and return



    #respond_to do |format|
      #if @csv.save
     #   format.csv  { send_data @csv_from_html, filename: "import.csv", type: 'text/csv', disposition: "attachment" }
     #   format.html { redirect_to root_url, notice: 'CSV was successfully created.' }
        #format.json { render json: @csv, status: :created, location: @csv }
      #else
       # format.html { render action: "new" }
       # format.json { render json: @csv.errors, status: :unprocessable_entity }
      #end
    #end
  end

  # PUT /csvs/1
  # PUT /csvs/1.json
  def update
    @csv = Csv.find(params[:id])

    respond_to do |format|
      if @csv.update_attributes(params[:csv])
        format.html { redirect_to @csv, notice: 'Csv was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @csv.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /csvs/1
  # DELETE /csvs/1.json
  def destroy
    @csv = Csv.find(params[:id])
    @csv.destroy

    respond_to do |format|
      format.html { redirect_to csvs_url }
      format.json { head :no_content }
    end
  end
end
