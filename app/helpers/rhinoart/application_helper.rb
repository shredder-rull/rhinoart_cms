module Rhinoart

  module ApplicationHelper

    def available_locales
      @available_locales ||= if current_user.present? and current_user.respond_to?(:locales) and current_user.locales.present?
           current_user.locales
         else
           I18n.available_locales
         end
    end

    def config
      Rhinoart.config
    end

    def tab_javascript
      <<-CODE
        $(function(){
          // добавление таба дополнительного контента
          var tabCount = $('#tabs li').length -1;
          $('#add_content').click(function() {
            var addContentName = prompt ("Введите наименование параметра","");
            if(addContentName == null || addContentName == '' || addContentName.length < 3) {
              alert('Наименование не заполнето или содержит мешьше 3-х символов');
              return false;
            }

            var html_tab  = '<li><input id="page_page_content_attributes___name___name" name="page[page_content_attributes][__name__][name]" type="hidden" value="'+addContentName+'">'+
                    '<a href="#form_contents_add___name___name_tab" data-toggle="tab" rel="form_contents_add___name___name_tab">'+addContentName+' <i class="icon-remove-sign del_tab"></i></a>'+
                    '</li>';
            var html_content = '<div class="tab-pane" id="form_contents_add___name___name_tab">'+
                    '<textarea cols="40" id="page_page_content_attributes___name___content" name="page[page_content_attributes][__name__][content]" rows="20"></textarea>'+
                    '<script type="text/javascript">$(".tab-pane > textarea").redactor({minHeight: 350, imageUpload: "#{upload_image_path}", imageGetJson: "#{image_list_path}", fileUpload: "#{upload_file_path}"});</script>'+
                    '</div>';

            html_tab     = html_tab.replace(/__name__/g, tabCount);
            html_content = html_content.replace(/__name__/g, tabCount);
            tabCount++;

            $('#tabs').append(html_tab);
            $('.tab-content').append(html_content);
            return false;
          });

          // Удаление таба дополнительного контента
          $('.del_tab').click(function() {
            var delrow = $(this).parent().parent();
            var parentId = $(this).parent().attr('rel');

            if(confirm('Вы уверены что хотите удалить вкладку дополнительного контента?')) {
              $('.tab-content #'+parentId).remove();
              delrow.remove();
              return false;
            }

            return false;
          });
        })
      CODE
    end

    def field_javascript
      <<-CODE
        $(function(){
          // Удаление параметра
          $('.del_field').click(function() {
            var row = $(this).parent().parent().parent();
            row.remove();
            return false;
          });
        })
      CODE
    end

    def translate(key, options = {})
      I18n.t("rhinoart.#{key}", {default: [:key]}.merge(options))
    end
    alias_method :t, :translate

    def user_name(user)
      "#{user.first_name} #{user.last_name}".presence || user.email
    end

    def build_default_fields(page)
      fields = page.fields
      page.fields.build(name: 'title', type: 'string') unless fields.find{|p| p.name == 'title'}
      page.fields.build(name: 'h1', type: 'string') unless fields.find{|p| p.name == 'h1'}
      page.fields.build(name: 'description', type: 'meta') unless fields.find{|p| p.name == 'description'}
      page.fields.build(name: 'keywords', type: 'meta') unless fields.find{|p| p.name == 'keywords'}
    end

  end

end