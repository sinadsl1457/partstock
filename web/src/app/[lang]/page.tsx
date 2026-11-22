// /ko, /en → VGA 시세판으로.
import { redirect } from "next/navigation";

export default async function LangHome({ params }: PageProps<"/[lang]">) {
  const { lang } = await params;
  redirect(`/${lang}/gpu`);
}
