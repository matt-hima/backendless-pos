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
  String get installAppTitle => 'Install LilyGO ERP';

  @override
  String get installAppBody =>
      'Install this order screen on Android, iOS, Windows, or macOS.';

  @override
  String get installAppHint =>
      'Use Install app, Add to Dock, or on iPhone/iPad Share → Add to Home Screen.';

  @override
  String get enableNotificationsButton => 'Enable notifications';

  @override
  String get notificationsEnabled => 'Notifications enabled';

  @override
  String get notificationsBlocked =>
      'Notifications are blocked in this browser';

  @override
  String get keepAwakeButton => 'Keep screen awake';

  @override
  String get screenAwakeEnabled =>
      'Screen will stay awake while this page is open';

  @override
  String get newOrderNotificationTitle => 'New order';

  @override
  String newOrderNotificationBody(String ref) {
    return 'Order $ref is ready to review.';
  }

  @override
  String get alwaysOnConnectionHint =>
      'Keep this installed app open for live WebRTC orders. If the device suspends it, the connection will show Reconnect needed.';

  @override
  String get iosInstallHint =>
      'On iPhone or iPad: Share → Add to Home Screen, then keep the app open for live orders.';

  @override
  String get backgroundSupportNav => 'Always-on & notifications';

  @override
  String get backgroundSupportTitle => 'Always-on & notifications';

  @override
  String get backgroundSupportSubtitle =>
      'Keep the portal connection visible and receive order alerts.';

  @override
  String get backgroundSupportWebTitle => 'Web app';

  @override
  String get backgroundSupportWebBody =>
      'Works while this page is open. The browser may suspend it when it is in the background.';

  @override
  String get backgroundSupportAndroidTitle => 'Android';

  @override
  String get backgroundSupportAndroidBody =>
      'A native foreground-service app is required for reliable background operation.';

  @override
  String get backgroundSupportIosTitle => 'iPhone & iPad';

  @override
  String get backgroundSupportIosBody =>
      'Install from Safari for quick access. Background alerts require Apple Push Notifications.';

  @override
  String get backgroundSupportChromeTitle => 'Chrome extension';

  @override
  String get backgroundSupportChromeBody =>
      'Install the extension to open the portal in a dedicated Chrome app tab.';

  @override
  String get downloadChromeExtensionButton => 'Download Chrome extension';

  @override
  String get backgroundSupportKeepOpen =>
      'For live WebRTC orders, keep the portal open on the always-on device.';

  @override
  String get deviceConnectionTitle => 'LAN device connection';

  @override
  String get deviceConnectionBody =>
      'The ESP32 is a LAN-only storage and attestation server. It does not serve the web app.';

  @override
  String get deviceUrlLabel => 'ESP32 LAN URL';

  @override
  String get deviceUrlHint => 'http://192.168.1.50:8000';

  @override
  String get saveDeviceUrlButton => 'Save device URL';

  @override
  String get scanDeviceQrButton => 'Scan device QR';

  @override
  String get deviceUrlSaved => 'Device URL saved';

  @override
  String get deviceReachable => 'Device is reachable';

  @override
  String get deviceUnavailable => 'Device is unavailable';

  @override
  String get deviceQrUnsupported =>
      'QR scanning is not supported in this browser. Enter the LAN URL manually.';

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
  String get checkoutInvoiceTitle => 'Invoice preview';

  @override
  String get paymentMethodLabel => 'Payment method';

  @override
  String get cashPaymentLabel => 'Cash';

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
  String get googleDriveBackupTooltip => 'Back up to Google Drive';

  @override
  String get googleDriveRestoreTooltip => 'Restore from Google Drive';

  @override
  String get googleSheetExportTooltip => 'Export to Google Sheet';

  @override
  String get googleSheetImportTooltip => 'Import from Google Sheet';

  @override
  String get googleWorkspaceClientMissing =>
      'Google Workspace is not configured for this deployment';

  @override
  String get googleWorkspaceBackupDone => 'Backup saved to Google Drive';

  @override
  String get googleWorkspaceRestoreDone => 'Backup restored from Google Drive';

  @override
  String googleWorkspaceSheetDone(Object url) {
    return 'Google Sheet exported: $url';
  }

  @override
  String get googleWorkspaceSheetIdLabel => 'Google Sheet ID or URL';

  @override
  String get googleWorkspaceSheetImportDone => 'Google Sheet imported';

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

  @override
  String get navDatabase => 'データベース';

  @override
  String get databaseSectionTitle => 'データベース';

  @override
  String get databaseSectionSubtitle => 'この端末のローカルデータベースのテーブルを閲覧し、クエリを実行します';

  @override
  String get sqlQueryLabel => 'SQLクエリ';

  @override
  String get sqlQueryHint => 'SELECT * FROM erp.llx_product';

  @override
  String get runQueryButton => '実行';

  @override
  String get queryEmptyResult => 'クエリの結果は0件でした。';

  @override
  String get tablesSectionTitle => 'テーブル';

  @override
  String get clearTableButton => 'テーブルを空にする';

  @override
  String clearTableConfirmTitle(String table) {
    return '$table を空にしますか？';
  }

  @override
  String get clearTableConfirmBody => 'このテーブルのすべての行が完全に削除されます。この操作は取り消せません。';

  @override
  String get statusQueryExecuted => 'クエリを実行しました';

  @override
  String get navRegister => '注文入力・会計';

  @override
  String get navRegisterSettlement => '点検・精算';

  @override
  String get navSalesAnalysis => '売上分析';

  @override
  String get navPosSettings => 'POS設定';

  @override
  String get noCategoryOption => 'カテゴリーなし';

  @override
  String get taxIncludedLabel => '価格に税込み';

  @override
  String get taxIncludedHint => 'この商品の価格が税抜きの場合はオフにしてください';

  @override
  String get newCategoryTitle => '新しいカテゴリー';

  @override
  String get editCategoryTitle => 'カテゴリーを編集';

  @override
  String get deleteCategoryConfirmTitle => 'このカテゴリーを削除しますか？';

  @override
  String get deleteCategoryConfirmBody => 'このカテゴリーの商品は未分類になります。この操作は取り消せません。';

  @override
  String get deleteButton => '削除';

  @override
  String get productsTabLabel => '商品';

  @override
  String get categoriesTabLabel => 'カテゴリー';

  @override
  String get newCategoryButton => '新しいカテゴリー';

  @override
  String get categoriesEmpty => 'カテゴリーがまだありません。';

  @override
  String productCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count件の商品',
    );
    return '$_temp0';
  }

  @override
  String get registerSectionTitle => '注文入力・会計';

  @override
  String get registerSectionSubtitle => '商品を選択して会計を行います';

  @override
  String get allCategoriesLabel => 'すべて';

  @override
  String get cartTitle => '注文内容';

  @override
  String get cartEmptyLabel => 'カートは空です';

  @override
  String get totalLabel => '合計';

  @override
  String get payButtonLabel => '支払いへ進む';

  @override
  String get registerNotOpenWarning => '会計の前に「点検・精算」画面でレジを開いてください';

  @override
  String get saleCompleteTitle => 'お会計を完了しました';

  @override
  String get saleCompleteBody => 'お支払いを受け付けました';

  @override
  String changeDueLabel(String amount) {
    return 'おつり：NT\$$amount';
  }

  @override
  String get okButton => 'OK';

  @override
  String get registerSettlementTitle => '点検・精算';

  @override
  String get registerSettlementSubtitle => 'レジを開閉し、売上を確認します';

  @override
  String get colOpenedAt => '開始';

  @override
  String get colClosedAt => '終了';

  @override
  String get colOpeningFloat => 'つり銭準備金';

  @override
  String get colCountedCash => '点検金額';

  @override
  String get registerHistoryTitle => '履歴';

  @override
  String get registerHistoryEmpty => 'レジの記録がまだありません。';

  @override
  String get openRegisterCardTitle => 'レジを開ける';

  @override
  String get openingFloatLabel => 'つり銭準備金';

  @override
  String get openRegisterButton => 'レジを開ける';

  @override
  String activeSessionTitle(String time) {
    return 'レジ開始：$time';
  }

  @override
  String openingFloatSummary(String amount) {
    return 'つり銭準備金：NT\$$amount';
  }

  @override
  String get closeRegisterButton => 'レジを締める';

  @override
  String get recentSalesTitle => '最近の会計';

  @override
  String get recentSalesEmpty => 'このレジではまだ会計がありません。';

  @override
  String get refundedChipLabel => '返品済み';

  @override
  String get refundButton => '返品';

  @override
  String get closeRegisterTitle => 'レジを締める';

  @override
  String expectedCashLabel(String amount) {
    return '理論現金：NT\$$amount';
  }

  @override
  String get countedCashLabel => '実現金';

  @override
  String varianceLabel(String amount) {
    return '差額：NT\$$amount';
  }

  @override
  String get refundConfirmTitle => 'この会計を返品しますか？';

  @override
  String get refundConfirmBody => '在庫が戻り、返品伝票が作成されます。この操作は取り消せません。';

  @override
  String get checkoutTitle => 'お会計';

  @override
  String get tenderedAmountLabel => 'お預り金額';

  @override
  String get completeSaleButton => '会計する';

  @override
  String get salesAnalysisSectionTitle => '売上分析';

  @override
  String get salesAnalysisSectionSubtitle => '日別・カテゴリー別・商品別の売上を確認します';

  @override
  String get rangeTodayLabel => '本日';

  @override
  String get range7dLabel => '7日間';

  @override
  String get range30dLabel => '30日間';

  @override
  String get rangeAllLabel => 'すべて';

  @override
  String get dailySalesLabel => '日別売上';

  @override
  String get exportCsvButton => 'CSVを出力';

  @override
  String get salesAnalysisEmpty => 'この期間の売上はありません。';

  @override
  String get salesByCategoryLabel => 'カテゴリー別売上';

  @override
  String get salesByProductLabel => '商品別売上';

  @override
  String get posSettingsSectionTitle => 'POS設定';

  @override
  String get posSettingsSectionSubtitle => '新規商品の税設定の初期値';

  @override
  String get defaultTaxModeLabel => '価格に税を含める（内税）';

  @override
  String get standardRateLabel => '標準税率（%）';

  @override
  String get reducedRateLabel => '軽減税率（%）';

  @override
  String get uncategorizedLabel => '未分類';
}
