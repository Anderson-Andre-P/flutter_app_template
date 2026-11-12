import 'package:material_ui/material_ui.dart';
import 'package:flutter_app_template/core/constants/strings/common_strings.dart';
import 'package:flutter_app_template/core/theme/app_colors.dart';
import 'package:flutter_app_template/core/widgets/app_cards.dart';
import 'package:flutter_app_template/core/widgets/app_media_placeholder.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

Widget _wide(Widget child) => SizedBox(width: 360.w, child: child);

void main() {
  testBothThemes('basic, media, progress and link cards', (tester, dark) async {
    var actions = 0;
    await pumpApp(
      tester,
      SingleChildScrollView(
        child: _wide(
          Column(
            children: [
              const AppBasicCard(
                overline: 'Básico',
                title: 'Título do cartão',
                body: 'Corpo curto de apoio.',
                footer: 'Rodapé de metadado',
              ),
              const AppMediaCard(
                media: AppMediaPlaceholder(kind: AppMediaKind.image),
                badge: 'Em operação',
                overline: 'Com imagem',
                title: 'Item 02',
                meta: 'ID-2026-0042 · Grupo A',
              ),
              AppProgressCard(
                overline: 'Com botão',
                title: 'Etapas pendentes',
                body: '3 de 5 itens concluídos.',
                progress: .6,
                actionLabel: 'Continuar',
                onAction: () => actions++,
              ),
              AppLinkCard(
                overline: 'Com link',
                title: 'Histórico do item',
                body: '28 eventos registrados.',
                linkLabel: 'Ver tudo',
                onLink: () => actions++,
              ),
            ],
          ),
        ),
      ),
      dark: dark,
    );
    expect(find.text('Rodapé de metadado'), findsOneWidget);
    expect(find.text('Em operação'), findsOneWidget);
    for (final label in ['Continuar', 'Ver tudo']) {
      await tester.ensureVisible(find.text(label));
      await tester.pump();
      await tester.tap(find.text(label));
    }
    expect(actions, 2);
  });

  testBothThemes('horizontal card with thumbnail, owner and date', (
    tester,
    dark,
  ) async {
    await pumpApp(
      tester,
      _wide(
        const AppHorizontalCard(
          thumbnail: AppMediaPlaceholder(kind: AppMediaKind.image),
          overline: 'Horizontal',
          badge: 'Média',
          title: 'Revisão periódica do módulo',
          body: 'Miniatura à esquerda, conteúdo à direita.',
          ownerInitials: 'RS',
          ownerLabel: 'Rafael Souza · Responsável',
          date: '11 ago',
        ),
      ),
      dark: dark,
    );
    expect(find.text('RS'), findsOneWidget);
    expect(find.text('11 ago'), findsOneWidget);
  });

  testBothThemes('product card: discount, favourite, rating, price, quantity', (
    tester,
    dark,
  ) async {
    final c = dark ? AppColors.dark : AppColors.light;
    var favourite = 0;
    final quantities = <int>[];
    var added = 0;
    await pumpApp(
      tester,
      SingleChildScrollView(
        child: _wide(
          AppProductCard(
            media: const AppMediaPlaceholder(kind: AppMediaKind.image),
            discount: '-15%',
            favorite: false,
            onFavorite: () => favourite++,
            title: 'Produto de exemplo',
            rating: 4.2,
            ratingLabel: '4,2 · 38 avaliações',
            price: r'R$ 289',
            oldPrice: r'R$ 340',
            quantity: 2,
            onQuantity: quantities.add,
            addLabel: 'Adicionar',
            onAdd: () => added++,
          ),
        ),
      ),
      dark: dark,
    );
    expect(find.byIcon(Icons.star), findsNWidgets(4));
    final old = tester.widget<Text>(find.text(r'R$ 340'));
    expect(old.style!.decoration, TextDecoration.lineThrough);
    expect(old.style!.color, c.textMuted);
    for (final target in [
      find.bySemanticsLabel(CommonStrings.favorite),
      find.bySemanticsLabel(CommonStrings.increase),
      find.text('Adicionar'),
    ]) {
      await tester.ensureVisible(target);
      await tester.pump();
      await tester.tap(target);
    }
    expect(favourite, 1);
    expect(quantities, [3]);
    expect(added, 1);
  });

  testBothThemes('call-to-action card on primary with a light button', (
    tester,
    dark,
  ) async {
    final c = dark ? AppColors.dark : AppColors.light;
    var created = 0;
    await pumpApp(
      tester,
      _wide(
        AppCtaCard(
          overline: 'Comece aqui',
          title: 'Nenhum modelo ativo ainda',
          body: 'Crie o primeiro modelo.',
          actionLabel: 'Criar modelo',
          onAction: () => created++,
          linkLabel: 'Ver exemplos',
          onLink: () {},
        ),
      ),
      dark: dark,
    );
    expect(
      tester.widget<Text>(find.text('Nenhum modelo ativo ainda')).style!.color,
      c.onPrimary,
    );
    await tester.tap(find.text('Criar modelo'));
    expect(created, 1);
  });

  testBothThemes('pricing card lists what is included', (tester, dark) async {
    await pumpApp(
      tester,
      SingleChildScrollView(
        child: _wide(
          AppPricingCard(
            overline: 'Plano',
            title: 'Operação',
            badge: 'Mais escolhido',
            price: r'R$ 69',
            period: '/ usuário / mês',
            features: const ['Registros ilimitados', 'Exportação'],
            actionLabel: 'Começar teste',
            onAction: () {},
            footnote: '30 dias grátis, sem cartão',
          ),
        ),
      ),
      dark: dark,
    );
    expect(find.byIcon(Icons.check), findsNWidgets(2));
    expect(find.text('Mais escolhido'), findsOneWidget);
  });

  testBothThemes('field card: value with unit, help and required attachment', (
    tester,
    dark,
  ) async {
    var attached = 0;
    await pumpApp(
      tester,
      SingleChildScrollView(
        child: _wide(
          AppFieldCard(
            title: 'Registrar valor',
            fieldLabel: 'Pressão',
            unit: 'bar',
            help: 'Faixa aceitável entre 3,0 e 4,0',
            actionLabel: 'Salvar',
            onAction: () {},
            attachmentLabel: 'Anexar comprovação',
            requiredLabel: 'Obrigatório',
            onAttach: () => attached++,
          ),
        ),
      ),
      dark: dark,
    );
    expect(find.text('bar'), findsOneWidget);
    expect(find.text('Faixa aceitável entre 3,0 e 4,0'), findsOneWidget);
    await tester.ensureVisible(find.text('Anexar comprovação'));
    await tester.pump();
    await tester.tap(find.text('Anexar comprovação'));
    expect(attached, 1);
  });
}
