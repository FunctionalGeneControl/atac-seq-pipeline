# ENCODE DCC ATAC-Seq/DNase-Seq pipeline tester for task macs2
# Author: Jin Lee (leepc12@gmail.com)
import "../../atac.wdl" as atac

workflow test_macs2 {
	Int cap_num_peak
	Float pval_thresh
	Int smooth_win

	# test macs2 for SE set only
	String se_ta

	String ref_se_macs2_npeak # raw narrow-peak
	String ref_se_macs2_bfilt_npeak # blacklist filtered narrow-peak
	String ref_se_macs2_frip_qc 
	String ref_se_macs2_sig_pval # p-val signal

	String se_blacklist
	String se_chrsz
	String se_gensz

	call atac.macs2 as se_macs2 { input :
		ta = se_ta,
		gensz = se_gensz,
		chrsz = se_chrsz,
		cap_num_peak = cap_num_peak,
		pval_thresh = pval_thresh,
		smooth_win = smooth_win,
		make_signal = true,
		blacklist = se_blacklist,
	}

	call atac.compare_md5sum { input :
		labels = [
			'se_macs2_npeak',
			'se_macs2_bfilt_npeak',
			'se_macs2_frip_qc',
			'se_macs2_sig_pval',
		],
		files = [
			se_macs2.npeak,
			se_macs2.bfilt_npeak,
			se_macs2.frip_qc,
			se_macs2.sig_pval,
		],
		ref_files = [
			ref_se_macs2_npeak,
			ref_se_macs2_bfilt_npeak,
			ref_se_macs2_frip_qc,
			ref_se_macs2_sig_pval,
		],
	}
}
