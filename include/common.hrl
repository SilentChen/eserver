%%ETS
-define(ETS_SYSTEM_INFO,  ets_system_info).						%% 系统配置信息
-define(ETS_MONITOR_PID,  ets_monitor_pid).						%% 记录监控的PID

%%ets read-write 属性
-define(ETSRC,{read_concurrency,true}).
-define(ETSWC,{write_concurrency,true}).

%%tcp_server监听参数
-define(TCP_OPTIONS, [binary, {packet, 0}, {active, false}, {reuseaddr, true}, {nodelay, false}, {delay_send, true}, {send_timeout, 5000}, {keepalive, true}, {exit_on_close, true}]).
-define(RECV_TIMEOUT, 5000).

-define(DIFF_SECONDS_1970_1900, 2208988800).
-define(DIFF_SECONDS_0000_1900, 62167219200).
-define(ONE_DAY_SECONDS, 86400).					%%一天的时间（秒）
-define(ONE_DAY_MILLISECONDS, 86400000).				%%一天时间（毫秒）

%%自然对数的底
-define(E, 2.718281828459).

%%调试级别记录
%%打印
-define(PRINT(Format),
  logger:test_msg(?MODULE, ?LINE, Format, [])).
-define(PRINT(Format, Args),
  logger:test_msg(?MODULE, ?LINE, Format, Args)).
%%调试级别记录
-define(DEBUG(Format),
  logger:debug_msg(?MODULE, ?LINE, Format, [])).
-define(DEBUG(Format, Args),
  logger:debug_msg(?MODULE, ?LINE, Format, Args)).
%%警告级别记录
-define(WARNING(Format),
  logger:warning_msg(?MODULE, ?LINE, Format, [])).
-define(WARNING(Format, Args),
  logger:warning_msg(?MODULE, ?LINE, Format, Args)).
%%错误级别记录
-define(ERR(Format),
  logger:error_msg(?MODULE, ?LINE, Format, [])).
-define(ERR(Format, Args),
  logger:error_msg(?MODULE, ?LINE, Format, Args)).

%%flash843安全沙箱
-define(FL_POLICY_REQ, <<"<polic">>).
-define(FL_POLICY_FILE, <<"<cross-domain-policy><allow-access-from domain='*' to-ports='*' /></cross-domain-policy>">>).