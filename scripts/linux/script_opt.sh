#!/bin/bash
CMD=$1
NODE=1
PATH_BASE=$( cd "$( dirname "$0"  )" && cd .. && cd .. && pwd  ) 
PATH_CONFIG=${PATH_BASE}/config
PATH_BEAMS_ALL="./ ../ebin ../ebin_mochi/ ../ebin_erlydtl/ ../ebin_server/ ../ebin_templates/ ../ebin_mysql/ "
PATH_BEAMS_REGULAR="./ ../ebin ../ebin_mochi/ ../ebin_erlydtl/ ../ebin_server/ ../ebin_mysql/ "
PATH_BEAMS_TEMPLATE="../ebin_templates/ "
PATH_TEMPLATE_BLOG_ADMIN=${PATH_BASE}/templates/blog/admin
DATETIME=`date "+%Y%m%d%H%M%S"`
PATH_LOG="${PATH_BASE}/logs/app_${NODE}_${DATETIME}.log"


############  some base funcs  #################
function log()
{
	msg=$1
	echo "################ ${msg}  ######################"
}

function option()
{
cat << EOF
usage:
	|-[re]make: [re]make all, include the regular and template
	|
	|-[re]make_regular 
	|
	|-[re]make_template
	|
	|-clean: clean all, include the regularand template 
	|
	|-clean_regular
	|
	|-clean_template
	|
	e-run[start|begin|r]
	|
	|-make_run: make and run
	|
	|-remake_run: remake all then run
	|
	|-remake_regular_run: remake regular then run
	|
	|-remake_template_run: remake template then run
	|
	|-check_env: to make sure the make and run env is been set up(suppose to run this at the first time you pull it down from github)

EOF
}

function check_env()
{
	cd ${PATH_CONFIG}
	DIRS="${PATH_BEAMS_ALL} ../logs"
	for p in ${DIRS}
	do
		if [ ! -d $p  ];then
			log "makeing the dir: {$p}"
			mkdir $p
		fi
	done
}

function cleanAllBeams ()
{
	log "clean all beams"
	cd ${PATH_CONFIG}
	for p in ${PATH_BEAMS_ALL}
		do
			cd $p
			rm -rf ./*.beam
	done
}

function cleanRegularBeams()
{
	log "clean regular beams"
	cd ${PATH_CONFIG}
	for p in ${PATH_BEAMS_REGULAR}
		do
			cd $p
			rm -rf ./*.beam
	done
}

function cleanTemplateBeams()
{
	log "clean template beams"
	cd ${PATH_CONFIG}
	for p in ${PATH_BEAMS_TEMPLATE}
		do
			cd $p
			rm -rf ./*.beam
	done
}

function make_regular()
{
	log "make regular"
	cd ${PATH_BASE}
	erl -make
}

function make_template()
{
log "make template"
cd ${PATH_BASE}
erl -pa ebin_erlydtl \
-noshell \
-eval " {ok,Files}=file:list_dir('${PATH_TEMPLATE_BLOG_ADMIN}'),Fun=fun(F)-> N=filename:basename(F,'.html'), erlydtl:compile(filename:join('${PATH_TEMPLATE_BLOG_ADMIN}',F),N,[{out_dir,'ebin_templates'},{debug_compiler, false}]) end, [Fun(F) || F<-Files]" \
-eval "init:stop()"

}

function run()
{
	log "runing..."
	cd ${PATH_CONFIG}
	erl +P 1024000 \
		+spp true \
		+sub true \
		+pc unicode \
		-smp enable \
		-name server@127.0.0.1 \
		-hidden true \
		-setcookie server \
		-boot start_sasl \
		-config server \
		-kernel error_logger \{file,\"$PATH_LOG\"\} \
		-pa ./ ../ebin ../ebin_mochi/ ../ebin_erlydtl/ ../ebin_server/ ../ebin_templates/ ../ebin_mysql/ \
		-s server \
		# -s reloader

}


#############  some reuse  #####################
function make_all()
{
	make_regular

	make_template
}

function remake_all()
{
	cleanAllBeams
	make_all
}

function remake_regular()
{
	cleanRegularBeams
	make_regular
}

function remake_template()
{
	cleanTemplateBeams
	make_template
}

function remake_run()
{
	remake_all
	run
}

function remake_regular_run()
{
	remake_regular
	run
}

function remake_template_run()
{
	remake_template
	run
}

function make_run()
{
	make_all
	run
}

case $CMD in
	check|check_env)
		check_env
		;;
	make|make_all|ma)
		make_all
		;;
	make_regular|mr)
		make_regular
		;;
	make_template|mt)
		make_template
		;;
	remake|remake_all|rma)
		remake_all
		;;
	remake_regular|rmr)
		remake_regular
		;;
	remake_template|rmt)
		remake_template
		;;
	run|r|start|begin)
		run
		;;
	clean|cleanAll|clean_all|ca)
		cleanAllBeams
		;;
	clean_regular|cr|cleanRegular)
		cleanRegularBeams
		;;
	clean_template|cleanTemplate|ct)
		cleanTemplateBeams
		;;
	make_run|makeRun|mr)
		make_run
		;;
	remake_run|remakeRun|rmr)
		remake_run
		;;
	remake_regular_run|remakeRegularRun)
		remake_regular_run
		;;
	remake_template_run|remakeTemplateRun)
		remake_template_run
		;;
	*)
		option
esac
