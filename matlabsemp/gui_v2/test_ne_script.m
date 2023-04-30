ne_test = 0.5:0.1:10;

load('20100814.mat','mdata')
for num = 1:length(ne_test)
    ne_par = ne_test(num);
    mdata.ne_par = ne_par;
    save(['data_paper_test_ne\20100814_ne_idx_',num2str(num),'.mat'], 'mdata');
end



for num = 1:length(ne_test)
    load(['data_paper_test_ne\20100814_ne_idx_',num2str(num),'.mat'], 'mdata');
    use_mdata_run_esti;
    save(['data_paper_test_ne\res\20100814_res_',num2str(num),'.mat','x'])
end

set(gca,'clim',[1.2 10]);
set(gca,'clim',[-2 45]) ;


