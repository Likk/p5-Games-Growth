package Games::Growth::Model::Character::Job::JA;
use 5.40.0;
use autodie;
use utf8;

=head1 NAME

  Games::Growth::Model::Character::Job::JA

=head1 DESCRIPTION

  Games::Growth::Model::Character::Job::JA is Japanese localization of the Games::Growth::Model::Character::Job module.

=head1 PACKAGE GLOBAL VARIABLES

=head2 JOB_LIST

  SEE ALSO $Games::Growth::Model::Character::Job::JOB_LIST

=head2 INITIAL_JOB

  SEE ALSO $Games::Growth::Model::Character::Job::INITIAL_JOB

=cut

local $Games::Growth::Model::Character::Job::JOB_LIST = +[ # 職業リスト。適当にいじってください
    +{
        name            => 'single_professional',
        threshold_point => [8, 18, 28, 38],
        distance        => [1,  2,  4,  6],
        entries => [
            +{ params => [qw/atk/], names => [qw/アタッカー     ブレイバー      バーサーカー    ブレイカー/    ]}, # 攻撃特化
            +{ params => [qw/def/], names => [qw/ディフェンダー アーマーナイト  ホプロマクス    パラディン/    ]}, # 防御特化
            +{ params => [qw/ldr/], names => [qw/ブースター     ストラテジスト  バンガード      アンセム/      ]}, # 指揮特化
            +{ params => [qw/agi/], names => [qw/スプリンター   スピードスター  ファントム      テンペスト/    ]}, # 敏捷特化
            +{ params => [qw/vit/], names => [qw/ファイター     ウォーリア      ヴァイキング    ガーディアン/  ]}, # 耐久特化
            +{ params => [qw/skl/], names => [qw/デュエリスト   アサイラント    スレイヤー      エグゼキュータ/]}, # 技術特化
        ],
    },
    +{
        name            => 'dual_professional',
        threshold_point => [12, 22, 42],
        distance        => [ 2,  3,  4],
        entries => [
            +{ params => [qw/atk def/], names => [qw/ブロウラー       クラッシャー        デストロイヤー/   ]},
            +{ params => [qw/atk ldr/], names => [qw/ストライカー     スマッシャー        ヴァンキッシャー/ ]},
            +{ params => [qw/atk agi/], names => [qw/アーチャー       ハンター            スナイパー/       ]},
            +{ params => [qw/atk vit/], names => [qw/バースター       スカミッシャー      ランページャー/   ]},
            +{ params => [qw/atk skl/], names => [qw/スラッシャー     グラディエイター    ソードマスター/   ]},
            +{ params => [qw/def ldr/], names => [qw/シューター       スイーパー          センチネル/       ]},
            +{ params => [qw/def agi/], names => [qw/ストーマー       インターセプター    ジャガーノート/   ]},
            +{ params => [qw/def vit/], names => [qw/タンク           フォートレス        エージス/         ]},
            +{ params => [qw/def skl/], names => [qw/デバッファー     ファランクス        アンブレイカブル/ ]},
            +{ params => [qw/ldr agi/], names => [qw/メッセンジャー   ヘラルド            ウォーバード/     ]},
            +{ params => [qw/ldr vit/], names => [qw/サポーター       ソルジャー          バスティオン/     ]},
            +{ params => [qw/ldr skl/], names => [qw/バッファー       サインメイカー      タクティシャン/   ]},
            +{ params => [qw/agi vit/], names => [qw/スカウト         レンジャー          サバイバー/       ]},
            +{ params => [qw/agi skl/], names => [qw/シーフ           アサシン            イレイサー/       ]},
            +{ params => [qw/vit skl/], names => [qw/バインダー       カウンター          トリックスター/   ]},
        ],
    },
    +{
        name            => 'generalist',
        threshold_point => [10, 20, 30, 40],
        distance        => [3,   5,  5,  5], # max - min
        entries => [ #all parameter
            +{ params => [qw//], names => [qw/バランサー ハーモナイザー オールマイティ ヒーロー/], },
        ],
    },
];

local $Games::Growth::Model::Character::Job::JOB_LIST::INITIAL_JOB = +{
    name  => 'ルーキー',
    score => 0,
};

