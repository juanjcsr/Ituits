module ApplicationHelper

	#Regresa el titulo en cada pagina
	def titulo_completo(page_title)
		base_title = "iTuits"
		if page_title.empty?
			base_title
		else
			"#{base_title} | #{page_title}"
		end
	end
end
