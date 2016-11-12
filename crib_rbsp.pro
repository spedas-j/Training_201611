; = = = = Load and plot Van Allen Probes data = = = = 
;
;Set time range
timespan, '2013-07-25', 1, /day

; Load Van Allen Probes A EMFISIS magnetometer data 
rbsp_load_emfisis, probe='a', coord='sm', cadence='4sec' 

; Load Van Allen Probes B EMFISIS magnetometer data 
rbsp_load_emfisis, probe='b', coord='sm', cadence='4sec' 

; Change color and add labels 
options, 'rbsp?_emfisis_l3_4sec_sm_Mag' , 'colors', [2,4,6]
options, 'rbsp?_emfisis_l3_4sec_sm_Mag' , 'labels', ['Bx','By','Bz'] 
stop 

; Load Van Allen Probes A MAGEIS electron and proton data 
!path = 'rbsp_tools:'+!path 
; Level-2
rbsp_load_ect_mageis2, probes='a', level='l2'
rbsp_load_ect_mageis2, probes='b', level='l2'
; Level-3
rbsp_load_ect_mageis2, probes='a', level='l3'
rbsp_load_ect_mageis2, probes='b', level='l3'

; PLOT downloaded Van Allen Probes data 
tvar = ['rbspa_emfisis_l3_4sec_sm_Mag', $
        'rbspa_ect_mageis_FESA', $
        'rbspb_emfisis_l3_4sec_sm_Mag', $
        'rbspb_ect_mageis_FESA'] 
tplot, tvar, title='Van Allen Probes data' 
tlimit, '2013-07-25/'+['20:30','22:30'] 
stop 


; = = = VAN ALLEN PROBES WAVE DATA = = = 
; 
; = = = = EMFISIS: Wave power spectra HFR (>10 kHz) = = = = 
timespan, '2013-07-25', 1
rbsp_load_emfisis_hfr, probes='a', datatype = 'spectra' 
rbsp_load_emfisis_hfr, probes='a', datatype = 'spectra-merged'
options, 'rbspa_emfisis_HFR_Spectra_gyro', 'zrange', 10^[-20.,-12.]
tplot, 'rbspa_emfisis_HFR_Spectra_gyro' 
;
; = = = = EMFISIS: Wave power spectra WFR (a few Hz - 10 kHz) = = = = 
rbsp_load_emfisis_wfr, probes='a', datatype = 'spectra' 
; 
; = = = = EMFISIS: Wave power spectral matrix WFR (a few Hz - 10 kHz) = = = = 
rbsp_load_emfisis_wfr, probes='a', datatype = 'spectra-all' 
; 

end 

