class BirthdaysController < ApplicationController
  # GET /birthdays/1
  # GET /birthdays/1.xml
  def show
    @birthday = Birthday.find_by_uuid(params[:uuid])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @birthday }
    end
  end

  # GET /birthdays/new
  # GET /birthdays/new.xml
  def new
    @birthday = Birthday.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @birthday }
    end
  end

  # POST /birthdays
  # POST /birthdays.xml
  def create
    @birthday = Birthday.new(params[:birthday])
    if @same = @birthday.find_same
      redirect_to( uuid_path(@same.uuid))
    else
      respond_to do |format|
        if @birthday.save
          format.html { redirect_to( uuid_path(@birthday.uuid), :notice => 'Birthday was successfully created.') }
        else
          format.html { render :action => "new" }
        end
      end
    end
    
  end

end
