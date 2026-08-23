// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => '店舗管理';

  @override
  String get portalLoginTitle => '店舗ログイン';

  @override
  String get cancelButton => 'キャンセル';

  @override
  String get saveButton => '保存';

  @override
  String get continueButton => '続ける';

  @override
  String get closeButton => '閉じる';

  @override
  String get createButton => '作成';

  @override
  String get editButton => '編集';

  @override
  String get skipButton => 'スキップ';

  @override
  String get signInWithPasskeyButton => 'パスキーでログイン';

  @override
  String get demoModeLandingButton => 'デモモードを試す';

  @override
  String get demoModeBannerText => 'デモモード';

  @override
  String get exitDemoButton => 'デモを終了';

  @override
  String get passkeySetupTitle => 'パスキーを設定しますか？';

  @override
  String get passkeySetupBody =>
      'この端末の指紋、顔認証、またはPINを使って次回から素早くログインできます。これはこの端末とブラウザでのみ有効な機能で、他の場所からアカウントにアクセスする手段ではありません。';

  @override
  String get passkeySetupButton => '設定する';

  @override
  String get passkeyManageButton => 'パスキーログインを設定';

  @override
  String passkeyUnsupportedError(String error) {
    return 'パスキーログインを利用できません：$error';
  }

  @override
  String get statusPasskeyEnrolled => 'この端末でパスキーログインの準備ができました';

  @override
  String get accountEntryTitle => 'ログイン';

  @override
  String get accountEntryBody =>
      '携帯電話番号と生年月日を入力してください。この端末に既にアカウントがあればログインし、なければ新しく作成します。';

  @override
  String get accountChoiceTitle => '詳細オプション';

  @override
  String get accountChoiceBody =>
      '独自のパスフレーズを設定した場合や、新しい端末でこのアカウントを復元したい場合にご利用ください。';

  @override
  String get accountUnlockButton => 'パスフレーズでログイン';

  @override
  String get accountHighSecurityButton => '高セキュリティ設定';

  @override
  String get accountRestoreButton => 'バックアップフレーズで復元する';

  @override
  String get accountAdvancedOptionsLink => '詳細オプション';

  @override
  String get accountMismatchError =>
      'その携帯電話番号と生年月日はこの端末のアカウントと一致しません。別の方法でログインするには「詳細オプション」をご利用ください。';

  @override
  String get accountSignInButton => 'ログイン';

  @override
  String get createPassphraseTitle => 'アカウントを作成する';

  @override
  String get createPassphraseHint => 'パスフレーズを作成してください（8文字以上）。復元はできません。';

  @override
  String get confirmPassphraseTitle => 'パスフレーズの確認';

  @override
  String get confirmPassphraseHint => '同じパスフレーズをもう一度入力してください。';

  @override
  String get passphraseMismatchMessage => 'パスフレーズが一致しませんでした';

  @override
  String get unlockTitle => 'ログイン';

  @override
  String get unlockHint => 'パスフレーズを入力してください。';

  @override
  String get noAccountFoundMessage => 'この端末にアカウントが見つかりません。先に作成してください。';

  @override
  String get restoreTitle => 'アカウントを復元する';

  @override
  String get restorePhraseFieldLabel => '12単語のバックアップフレーズ';

  @override
  String get setPassphraseTitle => 'パスフレーズを設定する';

  @override
  String get setPassphraseHint => 'パスフレーズを作成してください（8文字以上）。';

  @override
  String get restoreButton => '復元する';

  @override
  String get backupPhraseTitle => 'バックアップフレーズを保存してください';

  @override
  String get backupPhraseBody =>
      'この12単語を書き留めてオフラインで保管してください。これを持っている人は誰でもこのアカウントにアクセスできます。';

  @override
  String get backupPhraseConfirmCheckbox => 'バックアップフレーズを書き留めました';

  @override
  String get quickSetupWarning =>
      'この端末での日常利用にあたり、アカウントを保護します。より高い保護が必要な場合は「詳細オプション」をご利用ください。';

  @override
  String get quickSetupMobileLabel => '携帯電話番号';

  @override
  String get quickSetupBirthdayLabel => '生年月日（YYYY-MM-DD）';

  @override
  String get storeNameFieldLabel => '店舗名';

  @override
  String get storeNameDefault => 'マイストア';

  @override
  String get preferencesButton => '設定';

  @override
  String get preferencesTooltip => '設定';

  @override
  String get preferencesTitle => '設定';

  @override
  String get preferencesBody => '任意項目です。携帯電話番号と生年月日は暗号化された上で、この端末に記憶されます。';

  @override
  String get preferencesMobileLabel => '携帯電話番号';

  @override
  String get preferencesBirthdayLabel => '生年月日（YYYY-MM-DD）';

  @override
  String get preferencesLanguageLabel => '言語';

  @override
  String get preferencesRememberCheckbox => 'この内容を記憶する';

  @override
  String get preferencesSecurityNote =>
      'より高いセキュリティのために：バックアップフレーズはオフラインで保管し、この端末のデータが失われた場合の復元に利用してください。';

  @override
  String get accountGateHeadline => 'ログインして店舗管理を開く';

  @override
  String get accountGateBody =>
      'アカウントが店舗管理の鍵になります。ローカルアカウントは暗号化されたキーストアとして保存され、パスフレーズで保護されます。';

  @override
  String get chatTooltip => 'サポートとチャットする';

  @override
  String get chatWithSupportTitle => 'サポートとチャット';

  @override
  String get messageSupportHint => 'サポートにメッセージを送る';

  @override
  String get memberZoneTooltip => '会員専用ページ';

  @override
  String get memberZoneTitle => '会員専用ページ';

  @override
  String get clientMenuTitle => '単品メニュー';

  @override
  String clientMenuSubtitle(String channel) {
    return 'チャンネル：$channel ・ 料理をタップすると詳細を確認し、注文に追加できます';
  }

  @override
  String get menuFallbackCategory => 'メニュー';

  @override
  String get clientOrderLockedTitle => 'ログインして注文を送信';

  @override
  String get clientOrderUnlockedTitle => 'このアカウントのチャンネル注文';

  @override
  String get clientOrderLockedSubtitle => 'アカウントをお持ちの方のみ、ご自身の注文履歴を作成・確認できます。';

  @override
  String clientOrderUnlockedSubtitle(int count, String total) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '暗号化済み $count 件',
    );
    return '$_temp0 ・ 合計 NT\$$total';
  }

  @override
  String clientOrderTotalLabel(String total, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 点',
    );
    return '合計 NT\$$total（$_temp0）';
  }

  @override
  String get clientOrderConfirmButton => '注文を確定する';

  @override
  String get salesWorkspaceTitle => '営業ワークスペース';

  @override
  String get salesWorkspaceSubtitle => '業務メニュー';

  @override
  String get offlineTerminalFooter => 'オフライン業務端末';

  @override
  String get navOverview => '概要';

  @override
  String get navThirdParties => '取引先';

  @override
  String get navProducts => '商品';

  @override
  String get navOrders => '注文';

  @override
  String get navConnection => '接続';

  @override
  String get navSupport => 'サポート';

  @override
  String get createChannelButton => '店舗リンクを作成';

  @override
  String get channelNameFieldLabel => '店舗リンク名';

  @override
  String channelReadyTitle(String code) {
    return '店舗リンク $code の準備ができました';
  }

  @override
  String get printButton => '印刷';

  @override
  String get metricOrders => '注文';

  @override
  String get metricThirdParties => '取引先';

  @override
  String get metricProducts => '商品';

  @override
  String get storageCardTitle => 'ローカルストレージ';

  @override
  String storageCardSubtitle(String channel) {
    return '店舗リンク $channel は注文をこの端末に保存します。この画面を開いたままにしておくことが、お客様への注文リンクとチャットを有効に保つ方法です。';
  }

  @override
  String get customersSectionTitle => '取引先';

  @override
  String get customersSectionSubtitle => '取引先台帳';

  @override
  String get colName => '名前';

  @override
  String get colCustomerCode => '取引先コード';

  @override
  String get colEmail => 'メールアドレス';

  @override
  String get customersEmpty => '取引先はまだありません。';

  @override
  String get productsSectionTitle => '商品';

  @override
  String get productsSectionSubtitle => '商品カタログ';

  @override
  String get loadSampleMenuButton => 'サンプルメニューを読み込む';

  @override
  String get newProductButton => '新規商品';

  @override
  String get colReference => 'コード';

  @override
  String get colLabel => '名称';

  @override
  String get colPriceHt => '税抜価格';

  @override
  String get colVat => '税率';

  @override
  String get colStock => '在庫';

  @override
  String get translationsAction => '翻訳';

  @override
  String get productsEmpty => '商品がまだありません。新規作成するか、サンプルメニューを読み込んでください。';

  @override
  String get newProductTitle => '新規商品';

  @override
  String get editProductTitle => '商品を編集';

  @override
  String get fieldReference => 'コード';

  @override
  String get fieldLabel => '名称';

  @override
  String get fieldPriceHt => '税抜価格';

  @override
  String get fieldVat => '税率 %';

  @override
  String get fieldStock => '在庫';

  @override
  String get translationsDialogTitle => '翻訳';

  @override
  String get translationsLanguageLabel => '言語';

  @override
  String get translationsLabelField => '名称';

  @override
  String get translationsDescriptionField => '説明';

  @override
  String get ordersSectionTitle => '注文';

  @override
  String get ordersSectionSubtitle => '注文履歴';

  @override
  String orderTransactionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '取引 $count 件',
    );
    return '$_temp0';
  }

  @override
  String get ordersEmptyMock => '新しい注文は10秒ごとに自動で届きます。';

  @override
  String get operateTransactionTooltip => '注文を操作';

  @override
  String get validateOrderMenuItem => '確認済みにする';

  @override
  String get acceptOrderMenuItem => '受付済みにする';

  @override
  String get processOrderMenuItem => '処理中にする';

  @override
  String get deliverOrderMenuItem => '配達済みにする';

  @override
  String get cancelOrderMenuItem => '注文をキャンセル';

  @override
  String totalHtLabel(String total) {
    return '税抜合計 NT\$$total';
  }

  @override
  String totalTtcLabel(String total) {
    return '税込合計 NT\$$total';
  }

  @override
  String get orderStatusDraft => '下書き';

  @override
  String get orderStatusValidated => '確認済み';

  @override
  String get orderStatusAccepted => '受付済み';

  @override
  String get orderStatusProcessing => '処理中';

  @override
  String get orderStatusDelivered => '配達済み';

  @override
  String get orderStatusCanceled => 'キャンセル済み';

  @override
  String get orderStatusUnknown => '不明';

  @override
  String get supportSectionTitle => 'サポート';

  @override
  String supportSectionSubtitle(String channel) {
    return 'チャンネル $channel';
  }

  @override
  String get joinAsAgentButton => '担当者として参加';

  @override
  String get conversationsTab => '会話';

  @override
  String get activityLogTab => 'アクティビティログ';

  @override
  String get noActivityYet => 'まだアクティビティはありません。';

  @override
  String get noConversationsYet => 'まだ会話はありません。';

  @override
  String get noMessagesYet => 'メッセージはありません';

  @override
  String get selectConversationPrompt => '会話を選択してください';

  @override
  String get replyHint => 'お客様へ返信';

  @override
  String get roleOwnerLabel => 'オーナー';

  @override
  String get roleAgentLabel => '担当者';

  @override
  String get roleMemberLabel => 'メンバー';

  @override
  String get connectionConnected => '接続済み';

  @override
  String get connectionReconnectNeeded => '再接続が必要です';

  @override
  String get connectionConnecting => '接続中…';

  @override
  String get connectionNotConnected => '未接続';

  @override
  String get connectionSectionTitle => '接続';

  @override
  String get connectionSectionSubtitle => 'ライブチャット配信のための手動ペアリング';

  @override
  String get portalKeepOpenHint =>
      'この画面を開いたままにしてください — お客様への注文リンクとチャットを有効に保つために必要です。';

  @override
  String get connectionDefaultMessage => '公開リレーを使って経路を探索しています';

  @override
  String get generateOfferButton => 'ペアリングコードを生成';

  @override
  String get acceptOfferButton => 'ペアリングコードを入力';

  @override
  String get applyAnswerButton => '応答を適用';

  @override
  String get offerFieldLabel => 'ペアリングコード';

  @override
  String get answerFieldLabel => '応答コード';

  @override
  String get connectionOfferGeneratedMessage =>
      'ペアリングコードを生成しました。相手の端末と共有し、その応答を入力してください。';

  @override
  String get connectionAnswerGeneratedMessage =>
      '応答を生成しました。ペアリングコードを作成した端末に送り返してください。';

  @override
  String get connectionAnswerAppliedMessage => '接続が確立されました。';

  @override
  String connectionOfferErrorMessage(String error) {
    return 'ペアリングエラー：$error';
  }

  @override
  String connectionAcceptErrorMessage(String error) {
    return '応答エラー：$error';
  }

  @override
  String connectionApplyErrorMessage(String error) {
    return '接続エラー：$error';
  }

  @override
  String get connectionFooterNote =>
      'これは端末間の直接接続を見つけるための機能です。それ自体でメッセージ配信を行うものではありません。';

  @override
  String get statusStartingDb => 'ローカルデータベースを起動しています…';

  @override
  String statusClientStorageError(String error) {
    return 'ローカルストレージエラー：$error';
  }

  @override
  String get statusReadyMessage => '準備完了 — 店舗データを閲覧・管理できます';

  @override
  String statusStartupError(String error) {
    return '起動エラー：$error';
  }

  @override
  String statusOrderSynced(String ref, int lineCount, int bytes) {
    return '$ref を同期しました（$lineCount 行、$bytes バイト）';
  }

  @override
  String statusSyncError(String error) {
    return '同期エラー：$error';
  }

  @override
  String statusOrderStatusChanged(String statusLabel) {
    return '注文ステータスが $statusLabel に変更されました';
  }

  @override
  String statusProductSaved(String ref) {
    return '商品 $ref をローカルに保存しました';
  }

  @override
  String statusMenuLoaded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'サンプルメニュー商品 $count 件をローカルに読み込みました',
    );
    return '$_temp0';
  }

  @override
  String statusAccountCanceled(String error) {
    return 'ログインがキャンセルまたは失敗しました：$error';
  }

  @override
  String statusAccountConnected(String address) {
    return 'アカウントが接続され、暗号化を初期化しました：$address';
  }

  @override
  String get statusProfileDecryptError => '記憶されたプロフィールを復号できませんでした';

  @override
  String statusProfileSaved(String address) {
    return '$address 用に連絡先情報を暗号化して記憶しました';
  }

  @override
  String get statusProfileRemoved => '記憶していた連絡先情報を削除しました';

  @override
  String statusTransactionReadFailed(String error) {
    return '暗号化された取引の読み込みに失敗しました：$error';
  }

  @override
  String statusOrderSaved(String ref) {
    return '注文 $ref をこのアカウント用に暗号化し、オフラインで保存しました';
  }

  @override
  String get orderSavedSnackbar => '注文をオフラインで保存しました';

  @override
  String get statusBackupDownloaded => 'バックアップをダウンロードしました';

  @override
  String get statusBackupRestored => 'バックアップを復元しました';

  @override
  String statusRestoreFailed(String error) {
    return '復元に失敗しました：$error';
  }

  @override
  String get backupTooltip => 'データをバックアップ';

  @override
  String get restoreTooltip => 'データを復元';

  @override
  String get refreshTooltip => 'データを更新';

  @override
  String get restoreConfirmTitle => 'バックアップから復元しますか？';

  @override
  String get restoreConfirmBody =>
      '選択したバックアップファイルの内容で、現在の店舗および顧客データがすべて置き換えられます。この操作は取り消せません。';

  @override
  String orderStatusChangedLog(int orderId, String statusLabel) {
    return '注文 #$orderId → $statusLabel';
  }

  @override
  String productSavedLog(String ref, String price) {
    return '商品 $ref を保存しました（NT\$$price）';
  }

  @override
  String channelCreatedLog(String code, String name) {
    return 'チャンネル $code を作成しました：「$name」';
  }

  @override
  String accountConnectedLog(String address) {
    return 'アカウント $address が接続されました';
  }

  @override
  String agentJoinedLog(String address, String channel) {
    return '担当者 $address がチャンネル $channel に参加しました';
  }

  @override
  String get navContent => 'メニューコンテンツ';

  @override
  String get contentSectionTitle => 'メニューコンテンツ';

  @override
  String get contentSectionSubtitle => 'お客様向けの店頭コンテンツ';

  @override
  String get newContentItemButton => '新規項目';

  @override
  String get publishButton => 'クライアントへ公開';

  @override
  String get demoModeButton => 'デモモード';

  @override
  String get contentEmpty => 'コンテンツ項目はまだありません。';

  @override
  String get colCategory => 'カテゴリー';

  @override
  String get newContentItemTitle => '新規項目';

  @override
  String get editContentItemTitle => '項目を編集';

  @override
  String get fieldCategory => 'カテゴリー';

  @override
  String get fieldDescription => '説明';

  @override
  String get statusContentPublished => 'メニューコンテンツを接続中のクライアントに公開しました';

  @override
  String get resetDataButton => 'データをリセット';

  @override
  String get resetConfirmTitle => 'すべてのデータをリセットしますか？';

  @override
  String get resetConfirmBody =>
      'この端末上の店舗、サポート、メニューコンテンツ、ロイヤルティのすべてのデータが完全に削除されます。サインイン中のアカウントには影響しません。この操作は取り消せません。';

  @override
  String get statusDataReset => 'すべてのデータをリセットしました';

  @override
  String get navLoyalty => 'ロイヤルティ';

  @override
  String get loyaltySectionTitle => 'ロイヤルティ';

  @override
  String get loyaltySectionSubtitle => '顧客のポイントとランク';

  @override
  String get colWallet => 'アカウント';

  @override
  String get colPointsBalance => 'ポイント';

  @override
  String get colTier => 'ランク';

  @override
  String get adjustPointsButton => 'ポイントを調整';

  @override
  String get adjustPointsTitle => 'ポイントを調整';

  @override
  String get pointsFieldLabel => 'ポイント（利用時はマイナス値）';

  @override
  String get reasonFieldLabel => '理由';

  @override
  String get loyaltyEmpty => 'ロイヤルティアカウントはまだありません。';

  @override
  String get statusPointsAdjusted => 'ポイントを調整しました';

  @override
  String get navBookings => '予約';

  @override
  String get bookingsSectionTitle => '予約';

  @override
  String get bookingsSectionSubtitle => 'テーブル予約と状況';

  @override
  String get seedMachinesButton => 'サンプルテーブルを読み込む';

  @override
  String get machinesEmpty => 'テーブルはまだありません。サンプルテーブルを読み込んでください。';

  @override
  String get machineStateIdle => '空席';

  @override
  String get machineStateOccupied => '使用中';

  @override
  String get machineStateMaintenance => 'メンテナンス';

  @override
  String get setIdleButton => '空席にする';

  @override
  String get setMaintenanceButton => 'メンテナンスにする';

  @override
  String get bookingsEmpty => '予約はまだありません。';

  @override
  String get bookingStatusPlanned => '予約済み';

  @override
  String get bookingStatusReleased => '受付済み';

  @override
  String get bookingStatusInProgress => '利用中';

  @override
  String get bookingStatusCompleted => '完了';

  @override
  String get bookingStatusCanceled => 'キャンセル済み';

  @override
  String get releaseBookingMenuItem => '受付する';

  @override
  String get startBookingMenuItem => '利用開始';

  @override
  String get completeBookingMenuItem => '完了にする';

  @override
  String get cancelBookingMenuItem => 'キャンセル';

  @override
  String get clientBookingCardTitle => 'テーブルを予約する';

  @override
  String get clientBookingMachineLabel => 'テーブル';

  @override
  String get clientBookingTimeLabel => '時間';

  @override
  String get clientBookingPartySizeLabel => '人数';

  @override
  String get clientBookingSubmitButton => '予約をリクエスト';

  @override
  String get statusBookingRequested => '予約リクエストを送信しました';

  @override
  String get navAccessControl => 'アクセス管理';

  @override
  String get membersSectionTitle => 'メンバー';

  @override
  String get membersSectionSubtitle => 'この店舗のポータルにアクセスできる人と、その権限範囲';

  @override
  String get membersEmpty => 'メンバーはまだ追加されていません。アクセスできるのはあなただけです。';

  @override
  String get noRoleLabel => 'ロールなし';

  @override
  String get addMemberButton => 'メンバーを追加';

  @override
  String get walletAddressFieldLabel => '相手のアカウントアドレス';

  @override
  String get roleFieldLabel => 'ロール';

  @override
  String get rolesSectionTitle => 'ロール';

  @override
  String get newRoleButton => '新しいロール';

  @override
  String get roleNameFieldLabel => 'ロール名';

  @override
  String get statusRoleGranted => 'ロールを付与しました';

  @override
  String get statusRoleRevoked => 'ロールを削除しました';
}
