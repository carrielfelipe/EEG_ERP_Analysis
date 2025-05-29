% Inicializar EEGLAB
eeglab;

% Directorio donde están los archivos .set
set_dir = 'C:/Users/Usuario/Documents/Datos EEG/PWI_DATOS_EEG_PROCESADOS_BUENOS/Set_Epoch_por_Sujeto_4000ms';

% Obtener la lista de archivos .set en el directorio
file_list = dir(fullfile(set_dir, '*.set'));

% Recorrer todos los archivos .set
for i = 1:length(file_list)
    % Obtener el nombre completo del archivo
    file_name = file_list(i).name;
    file_path = fullfile(set_dir, file_name);
    
    try
        % Cargar el archivo .set
        EEG = pop_loadset('filename', file_name, 'filepath', set_dir);
        
        % Inicializar variables para almacenar eventos y latencias
        num_events = length(EEG.event); % Número total de eventos
        event_data = cell(num_events, 2); % Celda para almacenar tipo y latencia
        
        % Recorrer los eventos y extraer 'type' y 'latency'
        for j = 1:num_events
            event_data{j, 1} = EEG.event(j).type;       % Nombre de la marca
            event_data{j, 2} = EEG.event(j).latency;   % Latencia en samples
        end
        
        % Convertir a tabla para mejor visualización y exportación
        event_table = cell2table(event_data, 'VariableNames', {'Type', 'Latency'});
        
        % Construir el nombre del archivo de salida
        output_file_name = [erase(file_name, '.set'), '_Marcas_Eventos.csv'];
        output_file_path = fullfile(set_dir, output_file_name);
        
        % Guardar los datos en un archivo CSV
        writetable(event_table, output_file_path);
        
        % Mostrar mensaje de éxito
        fprintf('%s procesado y guardado como %s\n', file_name, output_file_name);
    catch ME
        % Manejo de errores
        fprintf('Error procesando %s: %s\n', file_name, ME.message);
    end
end
