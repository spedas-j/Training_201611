;- - - PLOT 1: Overview - - -
tvar = [$
      'OMNI_HRO_1min_BZ_GSM', $
      'OMNI_HRO_1min_Pressure', $
      'the_fgs_sm', $
      'the_psef_en_eflux', $
      'the_peer_en_eflux', $
      'rbspa_emfisis_l3_4sec_sm_Mag', $
      'rbspa_ect_mageis_FESA']
tplot, tvar, title='SAMPLE PLOT 1'

;- - - PLOT 2: Line plot for particle data  - - -
options, 'rbspa_ect_mageis_FESA', 'spec', 0
tvar = [$
      'OMNI_HRO_1min_BZ_GSM', $
      'OMNI_HRO_1min_Pressure', $
      'rbspa_emfisis_l3_4sec_sm_Mag', $
      'rbspa_ect_mageis_FESA']
tplot, tvar, title='SAMPLE PLOT 2'

end 
