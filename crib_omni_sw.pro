
;= = = = Load solar wind OMNI, SYM-H, and AE index data = = = = 

timespan, '2013-07-25', 1

; LOAD OMNI HIGH RESOLUTION (1-min) SOLAR WIND DATA 
omni_hro_load 
tplot_names, '*'
stop 

; LOAD 1-HOUR RESOLUTION OMNI SOLAR WIND DATA 
; INCL. DST, KP, ETC. 
omni2_load2 
tplot_names, '*'
stop 

; PLOT OMNI HIGH-RESOLUTION DATA 
tplot, ['OMNI_HRO_1min_BZ_GSM', $ 
        'OMNI_HRO_1min_proton_density', $ 
        'OMNI_HRO_1min_flow_speed'], $   
      title = 'OMNI data' 


end 
