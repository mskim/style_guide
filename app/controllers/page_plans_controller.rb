class PagePlansController < ApplicationController
  before_action :set_page_plan, only: [:show, :edit, :update, :select_template, :update_page,  :destroy]
  before_action :authenticate_user!

  # GET /page_plans
  # GET /page_plans.json
  def index
    @page_plans = PagePlan.all
  end

  # GET /page_plans/1
  # GET /page_plans/1.json
  def show
  end

  # GET /page_plans/new
  def new
    @page_plan = PagePlan.new
  end

  # GET /page_plans/1/edit
  def edit
    # puts "in edit #{@page_plan.page_number}"
    @page_templates = Section.where(page_number: @page_plan.page_number).all
    if @page_templates.length == 0
      @available_ad_type = []
    else
      @available_ad_type = @page_templates.map {|p| p.ad_type}.uniq
    end
  end

  # POST /page_plans
  # POST /page_plans.json
  def create
    @page_plan = PagePlan.new(page_plan_params)
    respond_to do |format|
      if @page_plan.save
        format.html { redirect_to @page_plan, notice: 'Page plan was successfully created.' }
        format.json { render :show, status: :created, location: @page_plan }
      else
        format.html { render :new }
        format.json { render json: @page_plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /page_plans/1
  # PATCH/PUT /page_plans/1.json
  def update
    respond_to do |format|
      current_ad_type       = @page_plan.ad_type
      current_advertiser    = @page_plan.advertiser
      current_section_name  = @page_plan.section_name
      
      if @page_plan.update(page_plan_params)
        # binding.pry
        # if @page = @page_plan.page
        if @page_plan.page.color_page != @page_plan.color_page
          @page_plan.page.color_page = @page_plan.color_page
          @page_plan.page.save            
        end
        # end
        @page_plan.set_pair_page_color
        new_ad_type = @page_plan.ad_type
        if current_ad_type != new_ad_type
          #if we have page and ad_type changed, update page layout
          if @page = @page_plan.page
            if new_template = Section.where(ad_type:new_ad_type, page_number:@page_plan.page_number ).first
              @page.change_template(new_template.id)
            else
              if @page.page_number.odd?
                new_template = Section.where(ad_type:new_ad_type, page_number:101).first
              else
                new_template = Section.where(ad_type:new_ad_type, page_number:100).first
              end
              new_template = Section.where(ad_type:new_ad_type).first
              unless new_template
                puts "can't find any section with ad_type of #{new_ad_type}"
              else
                @page.change_template(new_template.id)
              end
            end
          end
        end
       
        new_section_name = @page_plan.section_name
        # if current_section_name != new_section_name
        @page_plan.page.section_name = new_section_name
        @page_plan.page.save
        page_heading = @page_plan.page.page_heading
        page_heading.section_name = new_section_name
        page_heading.save
        page_heading.generate_pdf
        @page_plan.page.generate_pdf_with_time_stamp
        # end

        new_advertiser = @page_plan.advertiser
        if new_advertiser && new_advertiser != "" && current_advertiser != new_advertiser
        ad_box = @page_plan.page.ad_boxes.first
          if ad_box
            ad_box.advertiser = new_advertiser
            ad_box.save
          end
        end

        if (@page_plan.page_number == 12 || @page_plan.page_number == 13)
          if @page_plan.ad_type == "15단_브릿지"
            Spread.where(issue: @page_plan.issue).first_or_create
            @page_plan.set_pair_bridge_ad
          else
            # @page_plan.spread.destroy if @page_plan.spread
          end
        end
        format.html { redirect_to current_plan_issue_path(Issue.last.id)}
        format.json { render :show, status: :ok, location: @page_plan }
      else
        format.html { render :edit }
        format.json { render json: @page_plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /page_plans/1
  # DELETE /page_plans/1.json
  def destroy
    @page_plan.destroy
    respond_to do |format|
      format.html { redirect_to page_plans_url, notice: 'Page plan was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def select_template
    @page_plan.selected_template_id = params[:selected_template_id]
    @page_plan.dirty    = true
    @page_plan.save
    redirect_to current_plan_issue_path(@page_plan.issue_id), notice: '새로운 페이지 디자인이 성공적으로 선택 되었습니다.'
  end

  def update_page
    @page_plan.update_page
    @page_plan.dirty   = false
    @page_plan.save

    redirect_to current_plan_issue_path(@page_plan.issue_id), notice: '페이지 디자인이 성공적으로 변경 되었습니다.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_page_plan
      @page_plan = PagePlan.includes(:page).find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def page_plan_params
      params.require(:page_plan).permit(:page_number, :deadline, :section_name, :ad_type, :advertiser, :color_page, :selected_template_id, :issue_id)
      # params.require(:page_plan).permit(:page_number, :deadline, :section_name, :ad_type, :advertiser, :color_page, :selected_template_id, :issue_id)
    end
end
