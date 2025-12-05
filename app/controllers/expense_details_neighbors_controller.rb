class ExpenseDetailsResidentsController < ApplicationController
  def pay
    @expense_details_resident = ExpenseDetailsResident.find(params[:id])
    authorize @expense_details_resident

    if expense_params[:receipt].present?
      @expense_details_resident.receipt.attach(expense_params[:receipt])
    else
      Rails.logger.warn " No se recibió ningún archivo en :receipt"
    end

    @expense_details_resident.update!(status: "pending_approval")

    redirect_back fallback_location: root_path, notice: "Comprobante enviado. Queda pendiente de aprobación."
  end
  def approve
    @expense_details_resident = ExpenseDetailsResident.find(params[:id])
    authorize @expense_details_resident, :approve?
    @expense_details_resident.update(status: "approved", paid_at: Time.current)
    @expense_details_resident.reload
    redirect_back fallback_location: root_path, notice: "Comprobante aprobado correctamente."
  end

  def reject
    @expense_details_resident = ExpenseDetailsResident.find(params[:id])
    authorize @expense_details_resident, :reject?
    @expense_details_resident.update(status: "rejected")
    redirect_back fallback_location: root_path, alert: "Comprobante rechazado."
  end


  def expense_params
    params.require(:expense_details_resident).permit(:receipt)
  end
end
